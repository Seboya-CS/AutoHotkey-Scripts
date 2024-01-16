

; Nick retrieved this from https://www.computoredge.com/AutoHotkey/Downloads/LaunchWindow.ahk

Gui, Font, s20 cBlue, Arial

Gui, Add, Picture, w30 h-1 section gLaunchGoogle Icon1
     , C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
Gui, Add, Button, ys gLaunchGoogle, Google

Gui, Add, Picture, w30 h-1 section xs gLaunchFirefox Icon1
     , C:\Program Files (x86)\Mozilla Firefox\firefox.exe
Gui, Add, Button, ys gLaunchFirefox, Firefox

Gui, Add, Picture, w30 h-1 section xs gLaunchEdge Icon1
     , C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe
Gui, Add, Button, ys gLaunchEdge, Microsoft Edge

Gui, Add, Picture, w30 h-1 section xs gLaunchDropBox Icon1
      , C:\Users\%A_UserName%\AppData\Roaming\Dropbox\bin\Dropbox.exe
Gui, Add, Button, ys gLaunchDropBox, DropBox

Gui, Show, , Launch Program
Return

LaunchGoogle:
  Run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
  WinClose
Return

LaunchFirefox:
  Run "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" www.facebook.com
  WinClose
Return

LaunchEdge:
  Run C:\Windows\explorer.exe shell:Appsfolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge
  WinClose
Return

LaunchDropBox:
  Run C:\Users\%A_UserName%\Dropbox
  WinClose
Return