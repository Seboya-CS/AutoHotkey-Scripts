f3::suspend
^+c::
	sleep, 600
    Send, ^c
	sleep, 100
	Send, ^c
	sleep, 500
    string := Clipboard
    WinActivate, SEARCHEVERYTHING
    WinWaitActive, SEARCHEVERYTHING
    Send, < C:\Users\nmw59\Cd1 | B:\ | D:\ | "\Internal shared storage\save" > %string%