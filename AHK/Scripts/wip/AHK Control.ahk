#Requires AutoHotkey v2.0

;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Jack Dunning, ceeditor@computoredge.com
;
; Script Function: Control Panel for AutoHotkey Apps
; October 24, 2013	
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, default
Gui +AlwaysOnTop +Resize
Gui, Add, ListView, nosort r10 readonly vMyListView gMyListView , Active | AutoHotkey App 

ImageListID := IL_Create(4)  ; Create an ImageList to hold 10 small icons.
LV_SetImageList(ImageListID)  ; Assign the above ImageList to the current ListView.
    IL_Add(ImageListID, "RedDot.ico")  
    IL_Add(ImageListID, "GreenDot.ico")  
    IL_Add(ImageListID, "BlueDot.ico") 
    IL_Add(ImageListID, "SHELL32.dll",72) 

; Auto-execute section for QuikPlay

Menu, QuikPlay, Add,Pick What to Play, PickPlay
Menu, QuikPlay, Add,What's Playing?, WhatPlay
Menu, QuikPlay, Add,Next, PlayNext
Menu, QuikPlay, Add,Stop Play, PlayStop

Process, Exist, QuikPlay.exe
QuikPlay := ErrorLevel

If ErrorLevel = 0
  {
     LV_Add("Icon1","No","QuikPlay")
     Menu, QuikPlay, Disable,Pick What to Play
     Menu, QuikPlay, Disable,What's Playing?
     Menu, QuikPlay, Disable,Next
     Menu, QuikPlay, Disable,Stop Play
     Menu, QuikPlay, Add,Start QuikPlay App, StartStopQuikPlay
  }
Else
  {
     LV_Add("Icon2","Yes","QuikPlay")
     Menu, QuikPlay, Add,Exit QuikPlay App, StartStopQuikPlay
  }

; Auto-execute section for ClipJump

Menu, ClipJump, Add,Change Channel, ChangeChannel


Process, Exist, ClipJump.exe
ClipJump := ErrorLevel

If ErrorLevel = 0
  {
     LV_Add("Icon1","No","ClipJump")
     Menu, ClipJump, Disable,Change Channel
     Menu, ClipJump, Add,Start ClipJump App, StartStopClipJump
  }
Else
  {
     LV_Add("Icon2","Yes","ClipJump")
     Menu, ClipJump, Add,Exit ClipJump App, StartStopClipJump
  }

; Auto-execute section for ToDoList

Menu, ToDoList, Add, Show To Do List, ShowTodo

Process, Exist, ToDoList.exe
ToDoList := ErrorLevel

If ErrorLevel = 0
  {
     LV_Add("Icon1","No","To Do List")
     Menu, ToDoList, Add,Start To Do List App, StartStopToDoList
  }
Else
  {
     LV_Add("Icon2","Yes","To Do List")
     Menu, ToDoList, Add,Exit To Do List App, StartStopToDoList
  }

; Auto-execute section for Utilities

Menu, Utilities, Add,Setup Instant Text Hotkey, SetHotkey
Menu, Utilities, Add,Set Reminder, SetReminder
Menu, Utilities, Add,Check Grandkids Ages, KidsAges
Menu, Utilities, Add,Open Calculator, StartCalc
LV_Add("Icon4","Apps","Various Actions")

LV_ModifyCol(1,"AutoHdr")
Menu, Tray, Add, Show AutoHotkey Control, ShowControl

; Auto-execute section for showing AutoHotkeyControl window

WinGetPos,X1,Y1,W1,H1,Program Manager
X2 := W1-300
Gui, Show, x%x2% y50, AutoHotkey Control

Hotkey, ^!Y, ShowControl

Return

; End of the auto-execute section

ShowControl:
Gui, Show,, AutoHotkey Control
Return

MyListView:  ; This label was left in for future use
Return

; How right-click menus are selected

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
If A_GuiControl <> MyListView  ; Display the menu only for clicks inside the ListView.
    return

; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key

If A_EventInfo = 1
 Menu, QuikPlay, Show , %A_GuiX%, %A_GuiY%
If A_EventInfo = 2
 Menu, Clipjump, Show , %A_GuiX%, %A_GuiY%
If A_EventInfo = 3
 Menu, ToDoList, Show , %A_GuiX%, %A_GuiY%
If A_EventInfo = 4
 Menu, Utilities, Show , %A_GuiX%, %A_GuiY%
return

; For automatic resizing of the ListView window

GuiSize:  ; Expand or shrink the ListView in response to the user's resizing of the window.
if A_EventInfo = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
;GuiControl, Move, Button1, % "y" . (A_GuiHeight - 30) 
;GuiControl, Move, Edit1, % "y" . (A_GuiHeight - 30) . "W" . (A_GuiWidth - 90)

Return

; QuikPlay labels

PickPlay:
 Send, !#p
Return

WhatPlay:
 Send, !#w
Return

PlayNext:
 Send, !#n
Return

PlayStop:
 Send, !#s
Return

StartStopQuikPlay:

If QuikPlay = 0
 {
     Menu, QuikPlay, Enable,Pick What to Play
     Menu, QuikPlay, Enable,What's Playing?
     Menu, QuikPlay, Enable,Next
     Menu, QuikPlay, Enable,Stop Play
  Menu, QuikPlay, Rename,Start QuikPlay App,Exit QuikPlay App
  LV_Modify(1,"Icon2", "Yes")
  Run, C:\Users\%A_UserName%\AutoHotkey\QuikPlay.exe
  QuikPlay := 1
 }
Else
 {
     Menu, QuikPlay, Disable,Pick What to Play
     Menu, QuikPlay, Disable,What's Playing?
     Menu, QuikPlay, Disable,Next
     Menu, QuikPlay, Disable,Stop Play
  Menu, QuikPlay, Rename,Exit QuikPlay App,Start QuikPlay App
  LV_Modify(1,"Icon1", "No")
  Process, Close, QuikPlay.exe
  QuikPlay := 0
 }

Return

; ClipJump labels

StartStopClipjump:

If Clipjump = 0
 { 
  Menu, ClipJump, Enable,Change Channel
  Menu, Clipjump, Rename,Start Clipjump App,Exit Clipjump App
  LV_Modify(2,"Icon2", "Yes")
  Run, C:\Users\%A_UserName%\Documents\Clipjump\Clipjump.exe
  Clipjump := 1
 }
Else
 {
  Menu, ClipJump, Disable,Change Channel
  Menu, Clipjump, Rename,Exit Clipjump App,Start Clipjump App
  LV_Modify(2,"Icon1", "No")
  Process, Close, Clipjump.exe
  Clipjump := 0
 }

Return

ChangeChannel:
 Send, +^c
Return


; ToDoList labels

ShowTodo:
 DetectHiddenWindows, On
IfWinExist, To Do List
 WinRestore, To Do List
DetectHiddenWindows, Off
Return

StartStopToDoList:

If ToDoList = 0
 {
  Menu, ToDoList, Enable,Show To Do List
  Menu, ToDoList, Rename,Start To Do List App,Exit To Do List App
  LV_Modify(3,"Icon2", "Yes")
  Run, C:\Users\%A_UserName%\AutoHotkey\ToDoList.exe
  ToDoList := 1
 }
Else
 {
  Menu, ToDoList, Disable,Show To Do List
  Menu, ToDoList, Rename,Exit To Do List App,Start To Do List App
  LV_Modify(3,"Icon1", "No")
  Process, Close, ToDoList.exe
  ToDoList := 0
 }

Return

; Various other actions

SetReminder:
 Send, ^#r
Return

SetHotkey:
 Send, ^!h 
Return

KidsAges:
 Send, #!g
Return

StartCalc:
 Run, %A_Windir%\system32\calc.exe
Return