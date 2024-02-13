#Requires AutoHotkey v2.0
#SingleInstance force
DetectHiddenWindows true
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"

LaunchColorPicker(chromePath)
{
    global colorPickerHwnd
    lPath := A_ScriptDir
    fPath := lPath . "\ColorPicker.html"
    cmd := chromePath . ' --app="' . fPath '"'

    run cmd, , "Hide"
    MouseGetPos(&x, &y)
    x := x + 20
    y := y + 20
    colorPickerHwnd := WinWait("Color Picker: Template manager")
    WinMove(x, y, 300, 200, colorPickerHwnd)
    WinShow(colorPickerHwnd)
    return colorPickerHwnd
}

GetColor()
{
    MouseGetPos(&x, &y)
    color := PixelGetColor(x - 2, y - 2, "Slow")
    return color
}

!c::
{
    colorPickerHwnd := WinExist("Color Picker: Template manager")
    if (colorPickerHwnd = 0)
    {
        chromePath := "C:\Program Files\Google\Chrome\Application\chrome.exe"
        colorPickerHwnd := LaunchColorPicker(chromePath)
    }
    else
    {
        color := GetColor()
        WinKill(WinExist("Color Picker: Template manager"))
        A_Clipboard := color
    }
}