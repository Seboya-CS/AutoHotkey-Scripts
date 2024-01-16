#SingleInstance , Force 

;left monitor

^+q::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , -903, -1080
return

^+w::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 53, -1080  ; Move the window to x=0, y=0
return

^+e::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , -903, -540  ; Move the window to x=0, y=0
return

^+r::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 53, -540  ; Move the window to x=0, y=0
return






;right monitor

^+a::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 1015, -1080  ; Move the window to x=0, y=0
return

^+s::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 1975, -1080  ; Move the window to x=0, y=0
return

^+z::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 1015, -540  ; Move the window to x=0, y=0
return

^+x::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 1975, -540  ; Move the window to x=0, y=0
return




;laptop

!1::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 0, 0  ; Move the window to x=0, y=0
return

!2::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 960, 0  ; Move the window to x=0, y=0
return

!3::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 0, 654  ; Move the window to x=0, y=0
return


!4::  ; Control+J hotkey
WinGet, currentWindow, ID, A  ; Get the active window's ID
WinMove, ahk_id %currentWindow%, , 960, 654  ; Move the window to x=0, y=0
return

