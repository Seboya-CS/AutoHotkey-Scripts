#SingleInstance force

!+c:: ; hotkey
{
	If WinActive("Excel") ; WinActive returns a value depending on the parameters. If the indicated window is not the active window, it returns 0
	{
		string := A_Clipboard ; store contents of the clipboard into a variable (in this case A_Clipboard is just providing text value
		sleep 50
		send "^+c" ; I n Excel I use a Macro to copy text from a cell since the native copy adds quotation marks around copied cells, which is obnoxious. This is why I have two separate conditions for this script. You can delete this or change to a different window.
		sleep 50
		string2 := string "`r`n `r`n" A_Clipboard ; concatenate
		sleep 50
		A_Clipboard := string2 ; return to clipboard
	}
	Else
	{
		clipSaved := ClipboardAll() ; ClipboardAll() works with more than just text. It will store any object in the clipboard.
		sleep 50
		send "^+c"
		sleep 50
		newClip := ClipboardAll()
		sleep 50
		A_Clipboard := clipSaved "`r`n `r`n" newClip
	}
}