#SingleInstance force

!1::
{
string := A_Clipboard
Sleep 50
A_Clipboard := "Writer received a request to contact the client for technical support. Writer called and spoke with the client."
Sleep 100
Send "^v"
Sleep 100
A_Clipboard := string
}
