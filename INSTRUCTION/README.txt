1.Basic Timer
	hours,minutes,seconds:
		Set the first timer. tapping wil begin after 5.Timer equals or surpasses the value.
		
2. Energy Timer
	Seconds,Minutes:
		Set how long one energy takes to regenerate. http://summonerswar.wikia.com/wiki/Mysterious_Plant
	Energy Per Level:
		set how much energy one event costs.
	Sell Rune:
		Checked:
			Rune will be sold. 
		Unchecked:
			rune will be kept.
	Use Energy Timer:
		Checked:
			The bot will calculate How long to wait to regenerate energy equivalent to the cost set.
		Unchecked:
			Bot will use 1.Basic Timer
	Update Config:
		Updates tapCoords from cfg.cfg and saves and updates config in the bot.
			
3.
	Time Zone Info. PDT is global server time.

4. Energy Event & Select Profile
	Use Energy Event
		Checked:
			Overrides Use Energy Timer checkbox. Bot will use 1. Basic timer until energy used is greater or equal to Energy To Use Input box.
		Unchecked:
			Will use Use Energy Timer Checbox.
	Energy To Use
		Sets the limit of energy to use.
	What to do later
		Continue using Energy Timer:
			will switch to Energy Timer after energy used is greater or equal to Energy To Use. WARNING! settings on gui will not be updated. To see what current settings are consult Section 5.
		Stop will use Toggle to stop:
			has the same effect as TOGGLE button. Will stop sending the tap events.
	Select Profile
		It will list all files in BOT_LOCATION/CFGs/. NO SPACES ALLOWED in filename. After selecting any of listed entries setting will update.

5. Info Section
	STATUS:
		0:
			Bot is not sending taps to the device.
		1:
			Taps Will be sent.
		Timer:
			Time elapsed since last Event.
		Waiting Time:
			If Timer Equals or exceeds Timer a tep Event will be sent.
		Using Energy Timer
			Status of 2.Use Energy Timer checkbox
		Last Event
			24HR Time (CEST) when 3.Timer was greater or equal to 3.Waiting Time
		Total Events Sent
			Number of times when 3.Timer was greater or equal to 3.Waiting Time
		Rune Selling Status
			Status of 2.Sell Rune checkbox
		ADB Version
			Version of adb client used to send tap commands.
		Using Energy Limit
			Status of 4.Use Energy Event checkbox
		Energy Usage Limit
			Value of 4. Energy To Use InputBox.
		Next Action
			Action in 4.What to do later? ComboBox.
		Used Energy
			Total energy spent on all events. (events=3.Timer is greater or equal to 3.Waiting Time)
		
6. 
	Toggle:
		Toggles Sending Tap Events.
	Reset Timer:
		Sets 5.Timer to 00:00:00
	Force Event:
		Forces a Tap Event by setting Timer to an gigantic value.
	Gimme Shell
		Most likely Broken. To Fix go to line 149. and update the path to PATH_TO_BOT\ADBS.
	Reset Used Energy:
		Sets 5.Used Energy to 0.
		
7.
	IP:
		OPTIONAL! IP to connect to remote adb device.
	Reset Adb Server:
		Resets Adb server. Uses ADB in ADBS/VERSION/
	NUMERICAL VALUE DROPDOWN:
		Sets Adb Version. 31 is Adb version 1.0.31

8.
	Two Way Time Covnerter.
		ALL VALUES MUST BE PRESENT. THE FOLLOWING ARE INVALID 00:00:00 | 000:000:000:000 | 00:00:
		If any Value is changed and followed by {ENTER}, Value in other box will update.



