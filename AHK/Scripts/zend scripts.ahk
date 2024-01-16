Loop
{
Process, Exist, AutoHotkey.exe
If ErrorLevel <> 0
{
Process, Close, AutoHotkey.exe
}
Else
{
Process, Exist, AutoHotkey64.exe
If ErrorLevel <> 0
{
Process, Close, AutoHotkey64.exe
}
Else
{
Process, Exist, AutoHotkeyU64.exe
If ErrorLevel <> 0
{
Process, Close, AutoHotkeyU64.exe
}
Else
{
ExitApp
}
}
}
}