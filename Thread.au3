#include <GUIConstantsEx.au3>

#Region TU JEST W¥TKEK WORKER BOTA
Func WorkerThread()
	Local $adbPath = "" ;
	Local $ToggleBot = 0
	Local $ip = 0 ;
	Local $adbVersion = 39
	Local $hrs = 0 ;
	Local $mins = 0 ;
	Local $secs = 0 ;
	Local $SellRune = $GUI_UNCHECKED ;

	Local $energySecs = 0 ;
	Local $energyMins = 0 ;
	Local $useEnergyTimer = 0 ;
	Local $energyPerLevel = 0 ;

	Local $energyHrsToWait = 0 ;
	Local $energyMinsToWait = 0 ;
	Local $energySecsToWait = 0 ;
	Local $energyMinsToWait_60 = 0 ;
	Local $energySecsToWait_60 = 0 ;

	Local $energyEventEnergyLimitCurrent = 0;
	Local $energyEventChecked = $GUI_UNCHECKED;
	Local $energyEventEnergyLimitBot = 0;
	Local $energyEventNextActionBot;

	Local $milisPerEnergy;


	Local $beginDate = TimerInit() ;
	Local $milisToWait = 9999999999999999999 ;
	Local $last_Event = "0:0:0" ;
	Local $totalEvents = 0 ;

	Local $tapCoordsX[10];
	Local $tapCoordsY[10];

	Local $cfgPath = @WorkingDir & "\CFGs\"
	Local $lastCfg = IniRead(@WorkingDir & "\lastCfg.botData", "profile", "a", "Default.BotData")

	While True
		$msg = _AuThread_GetMessage()
		Switch $msg
			Case "ForceEventMsg"
				$beginDate = -9999999999999 ;

			Case "resetTimerMsg"
				$beginDate = TimerInit()

			Case "ConnectMsg"
				Local $AdbDevicesString = " "
				ShellExecuteWait($adbPath, "connect " & $ip, @WorkingDir, "", @SW_HIDE)
				Sleep(20)
				Local $iPID = Run($adbPath & " devices", @WorkingDir, @SW_HIDE, $STDOUT_CHILD)
				ProcessWaitClose($iPID)
				Local $sOutput = StdoutRead($iPID)
				Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)
				For $e In $aArray
					$AdbDevicesString = $AdbDevicesString & $e & "^"
				Next
				_AuThread_SendMessage(_AuThread_MainThread(), $AdbDevicesString)
				Sleep(2000)

			Case "ResetADBMsg"

				;odpal adb jak nie dzia³a. inaczej zawiesi przy zmianie portu


				ShellExecuteWait($adbPath, "kill-server", @WorkingDir, "", @SW_SHOW)
				ShellExecuteWait($adbPath, "start-server", @WorkingDir, "", @SW_SHOW)
				;ShellExecuteWait($adbPath,"tcpip 5555",@WorkingDir,"",@SW_SHOW)

			Case "UpdateMsg"
				$lastCfg = IniRead(@WorkingDir & "\lastCfg.last", "profile", "a", "Default.BotData")
				$hrs = IniRead($cfgPath & $lastCfg, "Timer", "hrs", 0)
				$mins = IniRead($cfgPath & $lastCfg, "Timer", "mins", 0)
				$secs = IniRead($cfgPath & $lastCfg, "Timer", "secs", 0)

				$ip = IniRead($cfgPath & $lastCfg, "ADB", "ip", "192.168.0.192")
				$adbVersion = IniRead($cfgPath & $lastCfg, "ADB", "version", 39)
				$adbPath = @WorkingDir & "\ADBS\" & $adbVersion & "\adb.exe" ;

				$SellRune = IniRead($cfgPath & $lastCfg, "Rune", "SellRune", 1)

				$energySecs = IniRead($cfgPath & $lastCfg, "Energy", "secs", 15)
				$energyMins = IniRead($cfgPath & $lastCfg, "Energy", "mins", 4)
				$useEnergyTimer = IniRead($cfgPath & $lastCfg, "Energy", "useEnergyTimer", $GUI_UNCHECKED)
				$energyPerLevel = IniRead($cfgPath & $lastCfg, "Energy", "perLevel", 7)
				$milisPerEnergy = $energyMins * 60 * 1000 + $energySecs * 1000

				If $useEnergyTimer == $GUI_UNCHECKED Then
					$milisToWait = $hrs * 60 * 60 * 1000 + $mins * 60 * 1000 + $secs * 1000
				Else
					$milisPerEnergy = $energyMins * 60 * 1000 + $energySecs * 1000
					$milisToWait = $milisPerEnergy * $energyPerLevel
				EndIf

				$energyEventChecked = IniRead($cfgPath & $lastCfg, "EnergyEvent", "useEvent", $GUI_UNCHECKED)
				$energyEventEnergyLimitBot = IniRead($cfgPath & $lastCfg, "EnergyEvent", "limit", 0)
				$energyEventNextActionBot = IniRead($cfgPath & $lastCfg, "EnergyEvent", "next", "Continue using Energy Timer")

				If $energyEventChecked == $GUI_UNCHECKED Then

				Else
					$useEnergyTimer = $GUI_UNCHECKED;
					$milisToWait = $hrs * 60 * 60 * 1000 + $mins * 60 * 1000 + $secs * 1000
				EndIf

				$tapCoordsX[0] = IniRead($cfgPath & $lastCfg, "TapCoords", "reveivex", 0)
				$tapCoordsX[1] = IniRead($cfgPath & $lastCfg, "TapCoords", "skrzynka1x", 0)
				$tapCoordsX[2] = IniRead($cfgPath & $lastCfg, "TapCoords", "skrzynka2x", 0)
				$tapCoordsX[3] = IniRead($cfgPath & $lastCfg, "TapCoords", "getMaterialsx", 0)
				$tapCoordsX[4] = IniRead($cfgPath & $lastCfg, "TapCoords", "getEssencesx", 0)
				$tapCoordsX[5] = IniRead($cfgPath & $lastCfg, "TapCoords", "getRunex", 0)
				$tapCoordsX[6] = IniRead($cfgPath & $lastCfg, "TapCoords", "sellRune1x", 0)
				$tapCoordsX[7] = IniRead($cfgPath & $lastCfg, "TapCoords", "sellRune2x", 0)
				$tapCoordsX[8] = IniRead($cfgPath & $lastCfg, "TapCoords", "replayx", 0)
				$tapCoordsX[9] = IniRead($cfgPath & $lastCfg, "TapCoords", "startBattlex", 0)

				$tapCoordsY[0] = IniRead($cfgPath & $lastCfg, "TapCoords", "reveivey", 0)
				$tapCoordsY[1] = IniRead($cfgPath & $lastCfg, "TapCoords", "skrzynka1y", 0)
				$tapCoordsY[2] = IniRead($cfgPath & $lastCfg, "TapCoords", "skrzynka2y", 0)
				$tapCoordsY[3] = IniRead($cfgPath & $lastCfg, "TapCoords", "getMaterialsy", 0)
				$tapCoordsY[4] = IniRead($cfgPath & $lastCfg, "TapCoords", "getEssencesy", 0)
				$tapCoordsY[5] = IniRead($cfgPath & $lastCfg, "TapCoords", "getRuney", 0)
				$tapCoordsY[6] = IniRead($cfgPath & $lastCfg, "TapCoords", "sellRune1y", 0)
				$tapCoordsY[7] = IniRead($cfgPath & $lastCfg, "TapCoords", "sellRune2y", 0)
				$tapCoordsY[8] = IniRead($cfgPath & $lastCfg, "TapCoords", "replayy", 0)
				$tapCoordsY[9] = IniRead($cfgPath & $lastCfg, "TapCoords", "startBattley", 0)

			Case "KillMeMsg"
				IniWrite($cfgPath & $lastCfg, "ADB", "ip", $ip)
				IniWrite($cfgPath & $lastCfg, "Timer", "hrs", $hrs)
				IniWrite($cfgPath & $lastCfg, "Timer", "mins", $mins)
				IniWrite($cfgPath & $lastCfg, "Timer", "secs", $secs)
				IniWrite($cfgPath & $lastCfg, "Rune", "SellRune", $SellRune)
				IniWrite($cfgPath & $lastCfg, "Energy", "secs", $energySecs)
				IniWrite($cfgPath & $lastCfg, "Energy", "mins", $energyMins)
				IniWrite($cfgPath & $lastCfg, "Energy", "useEnergyTimer", $useEnergyTimer)

			Case "ToggleMsg"
				$ToggleBot = Toggle($ToggleBot)

			Case "EnergyEventReset"
				$energyEventEnergyLimitCurrent = 0;

		EndSwitch

		;sendStatus
		$hoursWaited = Int(TimerDiff($beginDate) / (1000 * 60 * 60))
		$minsWatied = Int(TimerDiff($beginDate) / (1000 * 60))
		$secsWaited = Int(TimerDiff($beginDate) / 1000)

		$secWaited_60 = Int($secsWaited - $minsWatied * 60)
		$minWaited_60 = Int($minsWatied - $hoursWaited * 60)
		If $SellRune == $GUI_UNCHECKED Then
			$SellRuneStatusString = "NO"
		Else
			$SellRuneStatusString = "YES"
		EndIf

		If $energyEventChecked == $GUI_UNCHECKED Then
			$energyEventCheckedText = "NO"
		Else
			$energyEventCheckedText = "YES"
		EndIf

		If $useEnergyTimer == $GUI_UNCHECKED Then
			$UseEnergyStatusString = "NO"
		Else
			$UseEnergyStatusString = "YES"
		EndIf

		$statusInfo = "STAUS:" & $ToggleBot
		$statusInfo = $statusInfo & "^" & "Timer:" & "^" & StringFormat("%02d", $hoursWaited) & ":" & StringFormat("%02d", $minWaited_60) & ":" & StringFormat("%02d", $secWaited_60)
		If $useEnergyTimer == $GUI_UNCHECKED Then
			$statusInfo = $statusInfo & "^" & "Waiting Time" & "^" & StringFormat("%02d", $hrs) & ":" & StringFormat("%02d", $mins) & ":" & StringFormat("%02d", $secs)
		Else
			$energySecsToWait = $milisToWait / 1000
			$energyMinsToWait = Int($energySecsToWait / 60)
			$energyHrsToWait = Int($energyMinsToWait / 60)
			$energySecsToWait_60 = $energySecsToWait - $energyMinsToWait * 60
			$energyMinsToWait_60 = $energyMinsToWait - $energyHrsToWait * 60
			$statusInfo = $statusInfo & "^" & "Waiting Time" & "^" & StringFormat("%02d", $energyHrsToWait) & ":" & StringFormat("%02d", $energyMinsToWait_60) & ":" & StringFormat("%02d", $energySecsToWait_60)
		EndIf

		$statusInfo = $statusInfo & "^" & "Using Energy Timer" & "^" & $UseEnergyStatusString
		$statusInfo = $statusInfo & "^" & "Last Event" & "^" & $last_Event
		$statusInfo = $statusInfo & "^" & "Total Events Sent" & "^" & $totalEvents
		$statusInfo = $statusInfo & "^" & "Rune Selling Staus" & "^" & $SellRuneStatusString
		$statusInfo = $statusInfo & "^" & "ADB Version" & "^" & $adbVersion
		$statusInfo = $statusInfo & "^" & "Using Energy Limit" & "^" & $energyEventCheckedText
		$statusInfo = $statusInfo & "^" & "Energy Usage Limit" & "^" & $energyEventEnergyLimitBot
		$statusInfo = $statusInfo & "^" & "Next Action" & "^" & $energyEventNextActionBot
		$statusInfo = $statusInfo & "^" & "Used Energy" & "^" & $energyEventEnergyLimitCurrent
		;		$statusInfo=$statusInfo&
		_AuThread_SendMessage(_AuThread_MainThread(), $statusInfo)

		;obs³uga energyeventa; i zmiana w configu

		If $energyEventEnergyLimitBot <= $energyEventEnergyLimitCurrent Then
			If $energyEventNextActionBot == "Continue using Energy Timer" Then
				$useEnergyTimer = $GUI_CHECKED
				$milisToWait = $milisPerEnergy * $energyPerLevel
			EndIf

			If $energyEventNextActionBot == "Stop will use Toggle to stop" Then
				$ToggleBot = 0;
			EndIf

		EndIf


		;Bot Timer
		$miliseconds = Int(TimerDiff($beginDate))
		If $milisToWait < $miliseconds And $ToggleBot == 1 Then
			;ShellExecuteWait($adbPath,"connect "&$ip,@WorkingDir,"",@SW_HIDE)
			Sleep(20)

			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[0] & " " & $tapCoordsY[0], @WorkingDir, "", @SW_HIDE) ;Nie w reveive
			_AuThread_SendMessage(_AuThread_MainThread(), "Nie w Reveive")
			Sleep(Random(3000, 6000, 1))
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[1] & " " & $tapCoordsY[1], @WorkingDir, "", @SW_HIDE) ;pokaz Skrzynke
			_AuThread_SendMessage(_AuThread_MainThread(), "Pokaz Skrzynke")
			Sleep(Random(3000, 6000, 1))
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[2] & " " & $tapCoordsY[2], @WorkingDir, "", @SW_HIDE) ;Skrzynka i otwarcie
			_AuThread_SendMessage(_AuThread_MainThread(), "Skrzynka i otwarcie")
			Sleep(Random(3000, 6000, 1))
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[3] & " " & $tapCoordsY[3], @WorkingDir, "", @SW_HIDE) ;ok chcê materia³y
			_AuThread_SendMessage(_AuThread_MainThread(), "Ok chce Materialy")
			Sleep(Random(3000, 6000, 1))
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[4] & " " & $tapCoordsY[4], @WorkingDir, "", @SW_HIDE) ;Ok w Esencje
			_AuThread_SendMessage(_AuThread_MainThread(), "Ok w Esencje")
			Sleep(Random(3000, 6000, 1))

			If $SellRune == $GUI_UNCHECKED Then
				ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[5] & " " & $tapCoordsY[5], @WorkingDir, "", @SW_HIDE) ;Get rune
				_AuThread_SendMessage(_AuThread_MainThread(), "Get Rune")
				Sleep(Random(3000, 6000, 1))
			Else
				ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[6] & " " & $tapCoordsY[6], @WorkingDir, "", @SW_HIDE) ;Sell Rune
				_AuThread_SendMessage(_AuThread_MainThread(), "Sell Rune")
				Sleep(Random(3000, 6000, 1))
				ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[7] & " " & $tapCoordsY[7], @WorkingDir, "", @SW_HIDE) ;YES Sell Rune
				_AuThread_SendMessage(_AuThread_MainThread(), "Yes Sell RUNE!")
				Sleep(Random(3000, 6000, 1))
			EndIf

			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[8] & " " & $tapCoordsY[8], @WorkingDir, "", @SW_HIDE) ;Replay
			_AuThread_SendMessage(_AuThread_MainThread(), "Replay")
			Sleep(Random(3000, 6000, 1))
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[9] & " " & $tapCoordsY[9], @WorkingDir, "", @SW_HIDE) ;Start Battle
			_AuThread_SendMessage(_AuThread_MainThread(), "Start Battle")
			Sleep(Random(3000, 6000, 1))
			$last_Event = _NowTime()
			$totalEvents = $totalEvents + 1
			$beginDate = TimerInit()
			$energyEventEnergyLimitCurrent = $energyEventEnergyLimitCurrent + $energyPerLevel;
		EndIf
		Sleep(200)
	WEnd
EndFunc   ;==>WorkerThread

Func Toggle($i)
	If $i == 1 Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>Toggle

#EndRegion TU JEST W¥TKEK WORKER BOTA
