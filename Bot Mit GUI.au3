#include <Date.au3>
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include 'authread.au3'

_AuThread_Startup()
#Region ### START Koda GUI section ### Form=C:\Users\oem\SkyDrive\Programy\AutoItV3\summoners\GUI.kxf
$Form1 = GUICreate("Summoners Tablet Farm", 674, 439, 186, 120)
$InputHrs = GUICtrlCreateInput("InputHrs", 8, 32, 145, 21)
$Label1 = GUICtrlCreateLabel("Hours", 8, 8, 32, 17)
$Label2 = GUICtrlCreateLabel("Minutes", 8, 64, 41, 17)
$InputMins = GUICtrlCreateInput("InputMins", 8, 88, 145, 21)
$Label3 = GUICtrlCreateLabel("Seconds", 8, 120, 46, 17)
$InputSecs = GUICtrlCreateInput("InputSecs", 8, 144, 145, 21)
$DebugInfo = GUICtrlCreateLabel("DebugInfo", 320, 8, 166, 345)
$ToggleBotButton = GUICtrlCreateButton("Toggle", 496, 8, 171, 33)
$ConnectButton = GUICtrlCreateButton("Connect To Adb", 496, 176, 99, 25)
$ResetTimerButton = GUICtrlCreateButton("Reset Timer", 496, 80, 83, 25)
$ForceEventButton = GUICtrlCreateButton("Force Event", 496, 48, 171, 25)
$ResetAdbServerButton = GUICtrlCreateButton("Reset ADB server", 496, 208, 99, 25)
$GimmeShellButton = GUICtrlCreateButton("Gimme Shell", 584, 80, 83, 25)
$IPAddress1 = _GUICtrlIpAddress_Create($Form1, 496, 152, 130, 21)
_GUICtrlIpAddress_Set($IPAddress1, "0.0.0.0")
$UpdateCfgButton = GUICtrlCreateButton("Update Config", 8, 408, 75, 25)
$SellRuneCheck = GUICtrlCreateCheckbox("Sell Rune", 8, 360, 97, 17)
$InputEnergySecs = GUICtrlCreateInput("InputEnergySecs", 8, 224, 145, 21)
$Label4 = GUICtrlCreateLabel("Time to Regenerate 1 Energy", 8, 176, 143, 17)
$Label5 = GUICtrlCreateLabel("Seconds", 8, 200, 46, 17)
$Label6 = GUICtrlCreateLabel("Minutes", 8, 256, 41, 17)
$InputEnergyMins = GUICtrlCreateInput("InputEnergyMins", 8, 280, 145, 21)
$EnergyTimerCheck = GUICtrlCreateCheckbox("Use Energy Timer?", 8, 384, 113, 17)
$Label7 = GUICtrlCreateLabel("Energy Per Level", 8, 312, 85, 17)
$InputEnergyPerLevel = GUICtrlCreateInput("InputEnergyPerLevel", 8, 336, 145, 21)
$AdbVersionCombo = GUICtrlCreateCombo("Select Adb Version", 496, 240, 169, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "39|31")
$TimeZoneInfo = GUICtrlCreateLabel("TimeZoneInfo", 160, 8, 150, 225)
$EnergyEventCheckbox = GUICtrlCreateCheckbox("Use Energy Event", 160, 248, 113, 17)
$EnergyUsageLabel = GUICtrlCreateLabel("Energy To Use", 160, 272, 75, 17)
$energyEventEnergyUsageInput = GUICtrlCreateInput("energyInput", 160, 296, 121, 21)
$Label8 = GUICtrlCreateLabel("What to do later?", 160, 328, 86, 17)
$EnergyEventNextActionCombo = GUICtrlCreateCombo("EnergyEventNextActionCombo", 160, 352, 169, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Continue using Energy Timer|Stop will use Toggle to stop")
$energyEventResetUsedEnergy = GUICtrlCreateButton("Reset Used Energy", 496, 112, 171, 25)
$TimeConvertCestInput = GUICtrlCreateInput("TimeConvertCestInput", 496, 400, 121, 21)
GUICtrlCreateLabel("Time Converter DD:HH:MM:SS", 496, 288, 152, 17)
$Label9 = GUICtrlCreateLabel("Cest", 496, 384, 25, 17)
$Label10 = GUICtrlCreateLabel("Pdt", 496, 328, 20, 17)
$TimeConvertPdtInput = GUICtrlCreateInput("TimeConvertPdtInput", 496, 344, 121, 21)
$CfgSelectionBox = GUICtrlCreateCombo("CfgSelectionBox", 160, 408, 321, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$Label11 = GUICtrlCreateLabel("Select Profile", 160, 384, 66, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


;HotKeySet("{F4}","KillMe")

$workerThread = _AuThread_StartThread("WorkerThread")
$adbSPath = @WorkingDir & "\ADBS\"
$cfgPath = @WorkingDir & "\CFGs\"

$lastCfg = IniRead(@WorkingDir & "\lastCfg.botData", "profile", "a", "Default.BotData")

$CFGsList = _ArrayToString(_FileListToArray($cfgPath, "*.botData", $FLTA_FILES), "|", 1)
$arrayCFGsList = StringSplit($CFGsList, "|")
$CFGsListIndex = _ArraySearch($arrayCFGsList, $lastCfg)
GUICtrlSetData($CfgSelectionBox, "|" & $CFGsList, $arrayCFGsList[$CFGsListIndex])


;Get config
$mainHrs = IniRead($cfgPath & $lastCfg, "Timer", "hrs", 0)
$mainMins = IniRead($cfgPath & $lastCfg, "Timer", "mins", 0)
$mainSecs = IniRead($cfgPath & $lastCfg, "Timer", "secs", 0)

$mainIp = IniRead($cfgPath & $lastCfg, "ADB", "ip", "192.168.0.192")
$adbVersion = IniRead($cfgPath & $lastCfg, "ADB", "version", 39)

$SellRune = IniRead($cfgPath & $lastCfg, "Rune", "SellRune", $GUI_UNCHECKED)

$energySecs = IniRead($cfgPath & $lastCfg, "Energy", "secs", 15)
$energyMins = IniRead($cfgPath & $lastCfg, "Energy", "mins", 4)
$useEnergyTimer = IniRead($cfgPath & $lastCfg, "Energy", "useEnergyTimer", $GUI_UNCHECKED)
$energyPerLevel = IniRead($cfgPath & $lastCfg, "Energy", "perLevel", 7)

$energyEventUse = IniRead($cfgPath & $lastCfg, "EnergyEvent", "useEvent", $GUI_UNCHECKED)
$energyEventEnergyLimit = IniRead($cfgPath & $lastCfg, "EnergyEvent", "limit", 0)
$energyEventNextAction = IniRead($cfgPath & $lastCfg, "EnergyEvent", "next", "Continue using Energy Timer")

;show correct values on gui
GUICtrlSetData($InputHrs, $mainHrs)
GUICtrlSetData($InputMins, $mainMins)
GUICtrlSetData($InputSecs, $mainSecs)

_GUICtrlIpAddress_Set($IPAddress1, $mainIp)


$ADBVersionsList = _ArrayToString(_FileListToArray($adbSPath, "*", $FLTA_FOLDERS), "|", 1)
$arrayADBVersionsList = StringSplit($ADBVersionsList, "|")
$ADBVersionIndex = _ArraySearch($arrayADBVersionsList, $adbVersion)
GUICtrlSetData($AdbVersionCombo, "|" & $ADBVersionsList, $arrayADBVersionsList[$ADBVersionIndex])

GUICtrlSetState($SellRuneCheck, $SellRune)

GUICtrlSetData($InputEnergySecs, $energySecs)
GUICtrlSetData($InputEnergyMins, $energyMins)
GUICtrlSetState($EnergyTimerCheck, $useEnergyTimer)
GUICtrlSetData($InputEnergyPerLevel, $energyPerLevel)

;ustaw odpowioedni next action
$EnergyEventNextActionList = "Continue using Energy Timer|Stop will use Toggle to stop"
$arrayEnergyEventNextActionList = StringSplit($EnergyEventNextActionList, "|")
$energyEventNextActionIndex = _ArraySearch($arrayEnergyEventNextActionList, $energyEventNextAction)

GUICtrlSetData($EnergyEventNextActionCombo, "|" & $EnergyEventNextActionList, $arrayEnergyEventNextActionList[$energyEventNextActionIndex])
GUICtrlSetState($EnergyEventCheckbox, $energyEventUse)
GUICtrlSetData($energyEventEnergyUsageInput, $energyEventEnergyLimit)


;Ustaw Time Converter na Current Time;

Local $TimeConverterCestDate = 0, $TimeConverterCestTime = 0
_DateTimeSplit(_NowCalc(), $TimeConverterCestDate, $TimeConverterCestTime)
GUICtrlSetData($TimeConvertCestInput, StringFormat("%02d", $TimeConverterCestDate[3]) & ":" & StringFormat("%02d", $TimeConverterCestTime[1]) & ":" & StringFormat("%02d", $TimeConverterCestTime[2]) & ":" & StringFormat("%02d", $TimeConverterCestTime[3]))
_DateTimeSplit(CESTtoPDT(_NowCalc()), $TimeConverterCestDate, $TimeConverterCestTime)
GUICtrlSetData($TimeConvertPdtInput, StringFormat("%02d", $TimeConverterCestDate[3]) & ":" & StringFormat("%02d", $TimeConverterCestTime[1]) & ":" & StringFormat("%02d", $TimeConverterCestTime[2]) & ":" & StringFormat("%02d", $TimeConverterCestTime[3]))

;Tell Thread to read CFG
_AuThread_SendMessage($workerThread, "UpdateMsg")


While True
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			KillMe()

		Case $ToggleBotButton
			_AuThread_SendMessage($workerThread, "ToggleMsg")

		Case $ConnectButton
			_AuThread_SendMessage($workerThread, "ConnectMsg")

		Case $ResetTimerButton
			_AuThread_SendMessage($workerThread, "ResetTimerMsg")

		Case $ForceEventButton
			_AuThread_SendMessage($workerThread, "ForceEventMsg")

		Case $ResetAdbServerButton
			_AuThread_SendMessage($workerThread, "ResetADBMsg")

		Case $GimmeShellButton
			Run("cmd", $adbSPath & $adbVersion, @SW_SHOW)

		Case $UpdateCfgButton
			;najlpierw zapisz do ini
			IniWrite($cfgPath & $lastCfg, "ADB", "ip", _GUICtrlIpAddress_Get($IPAddress1))
			IniWrite($cfgPath & $lastCfg, "Timer", "hrs", GUICtrlRead($InputHrs))
			IniWrite($cfgPath & $lastCfg, "Timer", "mins", GUICtrlRead($InputMins))
			IniWrite($cfgPath & $lastCfg, "Timer", "secs", GUICtrlRead($InputSecs))
			IniWrite($cfgPath & $lastCfg, "Rune", "SellRune", GUICtrlRead($SellRuneCheck))
			IniWrite($cfgPath & $lastCfg, "Energy", "secs", GUICtrlRead($InputEnergySecs))
			IniWrite($cfgPath & $lastCfg, "Energy", "mins", GUICtrlRead($InputEnergyMins))
			IniWrite($cfgPath & $lastCfg, "Energy", "useEnergyTimer", GUICtrlRead($EnergyTimerCheck))
			IniWrite($cfgPath & $lastCfg, "Energy", "perLevel", GUICtrlRead($InputEnergyPerLevel))
			$adbVersion = GUICtrlRead($AdbVersionCombo)
			IniWrite($cfgPath & $lastCfg, "ADB", "version", $adbVersion)

			IniWrite($cfgPath & $lastCfg, "EnergyEvent", "useEvent", GUICtrlRead($EnergyEventCheckbox))
			IniWrite($cfgPath & $lastCfg, "EnergyEvent", "limit", GUICtrlRead($energyEventEnergyUsageInput))
			IniWrite($cfgPath & $lastCfg, "EnergyEvent", "next", GUICtrlRead($EnergyEventNextActionCombo))


			_AuThread_SendMessage($workerThread, "UpdateMsg")

		Case $energyEventResetUsedEnergy
			_AuThread_SendMessage($workerThread, "EnergyEventReset")

		Case $TimeConvertCestInput
			Local $TimeConvertCestDate = 0, $TimeConvertCestTime = 0, $TimeConvertCestInputString = GUICtrlRead($TimeConvertCestInput), $currentDateArray

			_DateTimeSplit(_NowCalc(), $currentDateArray, $TimeConvertCestTime)
			$TimeConvertCestInputStringArray = StringSplit($TimeConvertCestInputString, ":")

			$TimeConvertCestConvertDateString = $currentDateArray[1] & "-" & $currentDateArray[2] & "-" & $TimeConvertCestInputStringArray[1] & " " & $TimeConvertCestInputStringArray[2] & ":" & $TimeConvertCestInputStringArray[3] & ":" & $TimeConvertCestInputStringArray[4]
			_DateTimeSplit(CESTtoPDT($TimeConvertCestConvertDateString), $TimeConvertCestDate, $TimeConvertCestTime)
			GUICtrlSetData($TimeConvertPdtInput, StringFormat("%02d", $TimeConvertCestDate[3]) & ":" & StringFormat("%02d", $TimeConvertCestTime[1]) & ":" & StringFormat("%02d", $TimeConvertCestTime[2]) & ":" & StringFormat("%02d", $TimeConvertCestTime[3]))

		Case $TimeConvertPdtInput
			Local $TimeConvertPdtDate = 0, $TimeConvertPdtTime = 0, $TimeConvertPdtInputString = GUICtrlRead($TimeConvertPdtInput), $currentDateArray

			_DateTimeSplit(_NowCalc(), $currentDateArray, $TimeConvertPdtTime)
			$TimeConvertPdtInputStringArray = StringSplit($TimeConvertPdtInputString, ":")

			$TimeConvertPdtConvertDateString = $currentDateArray[1] & "-" & $currentDateArray[2] & "-" & $TimeConvertPdtInputStringArray[1] & " " & $TimeConvertPdtInputStringArray[2] & ":" & $TimeConvertPdtInputStringArray[3] & ":" & $TimeConvertPdtInputStringArray[4]
			_DateTimeSplit(PDTtoCEST($TimeConvertPdtConvertDateString), $TimeConvertPdtDate, $TimeConvertPdtTime)
			GUICtrlSetData($TimeConvertCestInput, StringFormat("%02d", $TimeConvertPdtDate[3]) & ":" & StringFormat("%02d", $TimeConvertPdtTime[1]) & ":" & StringFormat("%02d", $TimeConvertPdtTime[2]) & ":" & StringFormat("%02d", $TimeConvertPdtTime[3]))
		Case $CfgSelectionBox
			$lastCfg = GUICtrlRead($CfgSelectionBox)
			IniWrite(@WorkingDir & "\lastCfg.botData", "profile", "a", $lastCfg)
			;Get config
			$mainHrs = IniRead($cfgPath & $lastCfg, "Timer", "hrs", 0)
			$mainMins = IniRead($cfgPath & $lastCfg, "Timer", "mins", 0)
			$mainSecs = IniRead($cfgPath & $lastCfg, "Timer", "secs", 0)

			$mainIp = IniRead($cfgPath & $lastCfg, "ADB", "ip", "192.168.0.192")
			$adbVersion = IniRead($cfgPath & $lastCfg, "ADB", "version", 39)

			$SellRune = IniRead($cfgPath & $lastCfg, "Rune", "SellRune", $GUI_UNCHECKED)

			$energySecs = IniRead($cfgPath & $lastCfg, "Energy", "secs", 15)
			$energyMins = IniRead($cfgPath & $lastCfg, "Energy", "mins", 4)
			$useEnergyTimer = IniRead($cfgPath & $lastCfg, "Energy", "useEnergyTimer", $GUI_UNCHECKED)
			$energyPerLevel = IniRead($cfgPath & $lastCfg, "Energy", "perLevel", 7)

			$energyEventUse = IniRead($cfgPath & $lastCfg, "EnergyEvent", "useEvent", $GUI_UNCHECKED)
			$energyEventEnergyLimit = IniRead($cfgPath & $lastCfg, "EnergyEvent", "limit", 0)
			$energyEventNextAction = IniRead($cfgPath & $lastCfg, "EnergyEvent", "next", "Continue using Energy Timer")

			;show correct values on gui
			GUICtrlSetData($InputHrs, $mainHrs)
			GUICtrlSetData($InputMins, $mainMins)
			GUICtrlSetData($InputSecs, $mainSecs)

			_GUICtrlIpAddress_Set($IPAddress1, $mainIp)


			$ADBVersionsList = _ArrayToString(_FileListToArray($adbSPath, "*", $FLTA_FOLDERS), "|", 1)
			$arrayADBVersionsList = StringSplit($ADBVersionsList, "|")
			$ADBVersionIndex = _ArraySearch($arrayADBVersionsList, $adbVersion)
			GUICtrlSetData($AdbVersionCombo, "|" & $ADBVersionsList, $arrayADBVersionsList[$ADBVersionIndex])

			GUICtrlSetState($SellRuneCheck, $SellRune)

			GUICtrlSetData($InputEnergySecs, $energySecs)
			GUICtrlSetData($InputEnergyMins, $energyMins)
			GUICtrlSetState($EnergyTimerCheck, $useEnergyTimer)
			GUICtrlSetData($InputEnergyPerLevel, $energyPerLevel)

			;ustaw odpowioedni next action
			$EnergyEventNextActionList = "Continue using Energy Timer|Stop will use Toggle to stop"
			$arrayEnergyEventNextActionList = StringSplit($EnergyEventNextActionList, "|")
			$energyEventNextActionIndex = _ArraySearch($arrayEnergyEventNextActionList, $energyEventNextAction)

			GUICtrlSetData($EnergyEventNextActionCombo, "|" & $EnergyEventNextActionList, $arrayEnergyEventNextActionList[$energyEventNextActionIndex])
			GUICtrlSetState($EnergyEventCheckbox, $energyEventUse)
			GUICtrlSetData($energyEventEnergyUsageInput, $energyEventEnergyLimit)
			_AuThread_SendMessage($workerThread, "UpdateMsg")

	EndSwitch
	;Get Status String
	$statusString = _AuThread_GetMessage() ;
	If $statusString Then
		GUICtrlSetData($DebugInfo, StringReplace($statusString, "^", @CRLF))
	EndIf


	;display Date String
	Local $aCESTDate, $aCESTTime, $aPDTDate, $aPDTTime
	_DateTimeSplit(_NowCalc(), $aCESTDate, $aCESTTime)
	_DateTimeSplit(CESTtoPDT(_NowCalc()), $aPDTDate, $aPDTTime)

	$TimeZoneString = "PDT:"
	$TimeZoneString = $TimeZoneString & "^" & "DAY: " & StringFormat("%02d", $aPDTDate[3]) & "     " & StringFormat("%02d", $aPDTTime[1]) & ":" & StringFormat("%02d", $aPDTTime[2]) & ":" & StringFormat("%02d", $aPDTTime[3])
	$TimeZoneString = $TimeZoneString & "^" & "^CEST:"
	$TimeZoneString = $TimeZoneString & "^" & "DAY: " & StringFormat("%02d", $aCESTDate[3]) & "     " & StringFormat("%02d", $aCESTTime[1]) & ":" & StringFormat("%02d", $aCESTTime[2]) & ":" & StringFormat("%02d", $aCESTTime[3])
	;	$TimeZoneString=$TimeZoneString & "^" &
	;	$TimeZoneString=$TimeZoneString & "^" &
	;	$TimeZoneString=$TimeZoneString & "^" &
	;	$TimeZoneString=$TimeZoneString & "^" &
	$TimeZoneString = StringReplace($TimeZoneString, "^", @CRLF)
	GUICtrlSetData($TimeZoneInfo, $TimeZoneString)


	Sleep(50)
WEnd

Func CESTtoPDT($time)
	Return _DateAdd('h', -9, $time)
EndFunc   ;==>CESTtoPDT

Func PDTtoCEST($time)
	Return _DateAdd('h', 9, $time)
EndFunc   ;==>PDTtoCEST



#Region TU JEST WĄTKEK WORKER BOTA
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

				;odpal adb jak nie działa. inaczej zawiesi przy zmianie portu


				ShellExecuteWait($adbPath, "kill-server", @WorkingDir, "", @SW_SHOW)
				ShellExecuteWait($adbPath, "start-server", @WorkingDir, "", @SW_SHOW)
				;ShellExecuteWait($adbPath,"tcpip 5555",@WorkingDir,"",@SW_SHOW)

			Case "UpdateMsg"
				$lastCfg = IniRead(@WorkingDir & "\lastCfg.botData", "profile", "a", "Default.BotData")
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

		;obsługa energyeventa; i zmiana w configu

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
			ShellExecuteWait($adbPath, "shell input tap " & $tapCoordsX[3] & " " & $tapCoordsY[3], @WorkingDir, "", @SW_HIDE) ;ok chcę materiały
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

Func KillMe()
	_AuThread_SendMessage($workerThread, "KillMeMsg")
	Sleep(200)
	Exit
EndFunc   ;==>KillMe

#EndRegion TU JEST WĄTKEK WORKER BOTA
