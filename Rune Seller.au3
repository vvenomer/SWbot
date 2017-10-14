HotKeySet( "{F4}", "_stop")
HotKeySet( "{F3}", "toggler")
$toggler=0

$mousePosx=0;
$mousePosy=9;

While True
	If $toggler==1 Then

		MouseClick("left",$mousePosx, $mousePosy)
		Sleep(Random(100, 1000, 1))

		MouseClick("left",1463, 454)
		Sleep(Random(100, 1000, 1))

		MouseClick("left",666, 623)
		Sleep(Random(2000, 4000, 1))

	EndIf
WEnd



Func toggler()
   If $toggler==0 Then
		$toggler=1
		$mousePosx=MouseGetPos(0)
		$mousePosy=MouseGetPos(1)
   Else
	  $toggler=0
   EndIf
EndFunc

Func _stop()
	Exit
EndFunc