#SingleInstance Force
!+4::
{
CoordMode "Mouse", "Screen"
MouseGetPos &xpos, &ypos 
ToolTip "X:" xpos "; Y:" ypos
SetTimer () => ToolTip(), -5000
return
}