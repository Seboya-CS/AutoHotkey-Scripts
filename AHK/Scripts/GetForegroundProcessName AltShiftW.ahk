!+w::  ; Alt + Shift + w as the hotkey
{
	if ProcessExists("chrome.exe")
	{
		ucpID := WinExist("User Control Panel")
		devtoolsID := WinExist("DevTools")
		If devtoolsID AND ucpID
		{
			WinActivate("DevTools")
			msgbox "DevTools"
		}
		Else
		{
			Send "{F12}"
			msgbox "No devtools"
		}
	Else
	{
		msgbox "No chrome"
	}
}
return