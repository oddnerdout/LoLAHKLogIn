MsgBox, This program will log in the user at a specific time within 24 hours of activiation.  `n`nYou must make sure that `n\\all patches have been installed and `n\\that the computer does not go to sleep.

; asks for the username and password at these steps.  
; If CANCEL is pressed then it will exit the program.
InputBox, Username, Username Input, Username?
if ErrorLevel
{
	goto, EndIt
}
else
{
	InputBox, password, Enter Password, (your input will be hidden),hide
	if ErrorLevel
	{
		goto, EndIt
	}
	else
	{
		; sets up the time that you want the program to run (according to the system clock)
		; if CANCEL is pressed it will run the program right away
		InputBox, start_time, Time to execute, What time do you want the program to run? (use military time with no colon) Example: 2345 for 11:45pm.  Cancelling will run the macro immediately.
		If errorlevel
		{
			LogIn(ByRef Username, ByRef password)
		}
		else
		{
			StartAt(ByRef start_time)
			LogIn(ByRef Username, ByRef password)
		}
		
	}
}
EndIt:
	ExitApp

PasteInput(TextInput)
{
	clip1 := ClipboardAll
	clipboard = %TextInput%
	Send, ^v
	clipboard = %clip1%
	clip1 =
}

; this will start the launcher and then execute the login.
; Be aware that if the folder path for the lol.launcher.exe is different correct
; the path.
LogIn(Username, password)
{
	Run, "C:\Riot Games\League of Legends\lol.launcher.exe"
	WinWait, PVP.net Patcher, 
	IfWinNotActive, PVP.net Patcher, , WinActivate, PVP.net Patcher, 
	WinWaitActive, PVP.net Patcher, 
	MouseClick, left,  551,  17
	Sleep, 100
	MouseClick, left,  705,  533
	Sleep, 100
	WinWait, PVP.net Client, 
	IfWinNotActive, PVP.net Client, , WinActivate, PVP.net Client, 
	WinWaitActive, PVP.net Client, 
	Sleep, 15000
	PasteInput(ByRef Username)
	Send, {TAB}
	PasteInput(ByRef password)
	Send,{ENTER}
	MouseClick, left,  1084,  437
	Sleep, 100
}

StartAt(target_time)
{
	
	; Get target time in a format we can:
	;  - compare (with "<"), and
	;  - use to calculate "time delta" (with EnvSub.)
	target = %A_YYYY%%A_MM%%A_DD%%target_time%00

	; < comparison should be safe as long as both are in the *exact* same format.
	if (target < A_Now)
	{   ; time(today) has passed already, so use time(tomorrow)
		EnvAdd, target, 1, d
	}

	; Calculate how many seconds until the target time is reached.
	EnvSub, target, %A_Now%, Seconds

	; Sleep until the target is reached.
	Sleep, % target * 1000 ; (milliseconds)
}

