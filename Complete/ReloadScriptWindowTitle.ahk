#SingleInstance force

!r::
{
	title := WinGetTitle("A")
	pos := Instr(title, ".ahk")
	onlyTitle := Substr(title, 1, pos + 3)
	runCmd := '"' A_AHKPath '" ' '"' onlyTitle '"'
	Run runCmd
}