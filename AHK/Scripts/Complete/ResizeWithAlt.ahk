﻿; Easy Window Dragging -- KDE style (requires XP/2k/NT) -- by Jonny
; https://www.autohotkey.com
; This script makes it much easier to move or resize a window: 1) Hold down
; the ALT key and LEFT-click anywhere inside a window to drag it to a new
; location; 2) Hold down ALT and RIGHT-click-drag anywhere inside a window
; to easily resize it; 3) Press ALT twice, but before releasing it the second
; time, left-click to minimize the window under the mouse cursor, right-click
; to maximize it, or middle-click to close it.

; This script was inspired by and built on many like it
; in the forum. Thanks go out to ck, thinkstorm, Chris,
; and aurelian for a job well done.

; Change history:
; November 07, 2006: Optimized resizing code in !RButton, courtesy of bluedawn.
; February 05, 2006: Fixed double-alt (the ~Alt hotkey) to work with latest versions of AHK.

; The Double-Alt modifier is activated by pressing
; Alt twice, much like a double-click. Hold the second
; press down until you click.
;
; The shortcuts:
;  Alt + Left Button  : Drag to move a window.
;  Alt + Right Button : Drag to resize a window.
;  Double-Alt + Left Button   : Minimize a window.
;  Double-Alt + Right Button  : Maximize/Restore a window.
;  Double-Alt + Middle Button : Close a window.
;
; You can optionally release Alt after the first
; click rather than holding it down the whole time.


; This detects "double-clicks" of the alt key.
; V1toV2: Added Bracket before hotkey or Hotstring

; Note from Nick: I removed the double-alt functionality, as I never used it.

If (VerCompare(A_AhkVersion, "1.0.39.00") < 0)
{
    msgResult := MsgBox("This script may not work properly with your version of AutoHotkey. Continue?", "", 20)
    if (msgResult = "No")
    ExitApp()
}


; This is the setting that runs smoothest on my
; system. Depending on your video card and cpu
; power, you may want to raise or lower this value.
SetWinDelay(2)

CoordMode("Mouse")
return

!LButton::
{ 
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos(&KDE_X1, &KDE_Y1, &KDE_id)
	KDE_Win := WinGetMinMax("ahk_id " KDE_id)
	If KDE_Win
		return
	; Get the initial window position.
	WinGetPos(&KDE_WinX1, &KDE_WinY1, , , "ahk_id " KDE_id)
	Loop
	{
		KDE_Button := GetKeyState("LButton", "P") ? "D" : "U" ; Break if button has been released.
		if (KDE_Button = "U")
			break
		MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
		KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
		WinMove(KDE_WinX2, KDE_WinY2, , , "ahk_id " KDE_id) ; Move the window to the new position.
	}
return
}

!RButton::
{
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos(&KDE_X1, &KDE_Y1, &KDE_id)
	KDE_Win := WinGetMinMax("ahk_id " KDE_id)
	If KDE_Win
		return
	; Get the initial window position and size.
	WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)
	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
		KDE_WinLeft := 1
	Else
		KDE_WinLeft := -1
	If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
		KDE_WinUp := 1
	Else
		KDE_WinUp := -1
	Loop			
	{
		KDE_Button := GetKeyState("RButton", "P") ? "D" : "U" ; Break if button has been released.
		if (KDE_Button = "U")
			break
		MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
		; Get the current window position and size.
		WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		; Then, act according to the defined region.
		WinMove(KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2, KDE_WinY1 + (KDE_WinUp+1)/2*KDE_Y2, KDE_WinW - KDE_WinLeft *KDE_X2, KDE_WinH - KDE_WinUp *KDE_Y2, "ahk_id " KDE_id) ; X of resized window
		KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
		KDE_Y1 := (KDE_Y2 + KDE_Y1)
	}
}