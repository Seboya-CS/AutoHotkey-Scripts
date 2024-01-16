#SingleInstance force

!+c::
{
	If WinActive("Excel")
{
	{
		string := A_Clipboard
		sleep 50
		send "^+c"
		sleep 50
		string2 := string A_Clipboard
		sleep 50
		A_Clipboard := string
	}
	Else
	{
		string := A_Clipboard
		sleep 50
		send "^c"
		sleep 50
		string2 := string A_Clipboard
		sleep 50
		A_Clipboard := string2
	}
}