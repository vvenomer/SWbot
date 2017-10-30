#include <Date.au3>
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include 'Thread.au3'

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


$workerThread = _AuThread_StartThread("WorkerThread")
$adbSPath = @WorkingDir & "\ADBS\"
$cfgPath = @WorkingDir & "\CFGs\"

If FileExists(@WorkingDir & "\lastCfg.last") Then
	$lastCfg = IniRead(@WorkingDir & "\lastCfg.last", "profile", "a", "Default.BotData")
EndIf
If FileExists($cfgPath & $lastCfg) Then

ElseIf FileExists($cfgPath & "Default.botData") Then
	$lastCfg = "Default.botData"
Else
	$aTemp=_FileListToArray($adbSPath, "*", $FLTA_FOLDERS)
	_CreateDefaultConfig("Default.botData",$aTemp[1])
	$lastCfg="Default.botData"
EndIf


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
If @error Then
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Critical
	MsgBox(16,"ADB Not Found","Adb Client not found. Consult README top section for more info.")
EndIf



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
			IniWrite(@WorkingDir & "\lastCfg.last", "profile", "a", $lastCfg)
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

Func KillMe()
	_AuThread_SendMessage($workerThread, "KillMeMsg")
	Sleep(200)
	Exit
EndFunc   ;==>KillMe

Func _CreateDefaultConfig($name,$adbVersion)
	IniWrite($cfgPath & $name, "ADB", "ip", "192.168.0.1")
	IniWrite($cfgPath & $name, "Timer", "hrs", 0)
	IniWrite($cfgPath & $name, "Timer", "mins", 2)
	IniWrite($cfgPath & $name, "Timer", "secs", 0)
	IniWrite($cfgPath & $name, "Rune", "SellRune", $GUI_UNCHECKED)
	IniWrite($cfgPath & $name, "Energy", "secs", 0)
	IniWrite($cfgPath & $name, "Energy", "mins", 5)
	IniWrite($cfgPath & $name, "Energy", "useEnergyTimer", $GUI_CHECKED)
	IniWrite($cfgPath & $name, "Energy", "perLevel", 3)
	IniWrite($cfgPath & $name, "ADB", "version", $adbVersion)
	IniWrite($cfgPath & $name, "EnergyEvent", "useEvent", $GUI_UNCHECKED)
	IniWrite($cfgPath & $name, "EnergyEvent", "limit", 0)
	IniWrite($cfgPath & $name, "EnergyEvent", "next", "Continue using Energy Timer")

	IniWrite($cfgPath & $name, "TapCoords", "reveivex", 1000)
	IniWrite($cfgPath & $name, "TapCoords", "skrzynka1x", 200)
	IniWrite($cfgPath & $name, "TapCoords", "skrzynka2x", 200)
	IniWrite($cfgPath & $name, "TapCoords", "getMaterialsx", 720)
	IniWrite($cfgPath & $name, "TapCoords", "getEssencesx", 722)
	IniWrite($cfgPath & $name, "TapCoords", "getRunex", 757)
	IniWrite($cfgPath & $name, "TapCoords", "sellRune1x", 690)
	IniWrite($cfgPath & $name, "TapCoords", "sellRune2x", 676)
	IniWrite($cfgPath & $name, "TapCoords", "replayx", 444)
	IniWrite($cfgPath & $name, "TapCoords", "startBattlex", 1331)

	IniWrite($cfgPath & $name, "TapCoords", "reveivey", 600)
	IniWrite($cfgPath & $name, "TapCoords", "skrzynka1y", 200)
	IniWrite($cfgPath & $name, "TapCoords", "skrzynka2y", 200)
	IniWrite($cfgPath & $name, "TapCoords", "getMaterialsy", 720)
	IniWrite($cfgPath & $name, "TapCoords", "getEssencesy", 816)
	IniWrite($cfgPath & $name, "TapCoords", "getRuney", 686)
	IniWrite($cfgPath & $name, "TapCoords", "sellRune1y", 690)
	IniWrite($cfgPath & $name, "TapCoords", "sellRune2y", 575)
	IniWrite($cfgPath & $name, "TapCoords", "replayy", 483)
	IniWrite($cfgPath & $name, "TapCoords", "startBattley", 604)


EndFunc

