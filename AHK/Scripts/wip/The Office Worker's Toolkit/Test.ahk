#Requires AutoHotkey v2.0
#SingleInstance force
#Include "C:\Users\westn\OneDrive\OneDrive\all documents\Github repositories\Seboya\AutoHotkey-Scripts\Complete\lib"
SetWorkingDir A_ScriptDir
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"

class cBase
{
    btnWidth
    {
        get {
            return this.btnWidth
        }
        set(value) {
            if (ValidateInteger10to100(value)) {
                this.btnWidth := value
            }
        }
    }
    btnHeight
    {
        get {
            return this.btnHeight
        }
        set(value) {
            if (ValidateInteger10to100(value)) {
                this.btnHeight := value
            }
        }
    }  
    textMaxWidth
    {
        get {
            return this.textMaxWidth
        }
        set(value) {
            if (ValidateInteger10to100(value)) {
                this.textMaxWidth := value
            }
        }
    }
    textMaxHeight
    {
        get {
            return this.textMaxHeight
        }
        set(value) {
            if (ValidateInteger10to100(value)) {
                this.textMaxHeight := value
            }
        }
    }
    textLeftorRight
    {
        get {
            return this.textLeftorRight
        }
        set(value) {
            if (value = "left" || value = "right") {
                this.textLeftorRight := value
            } else {
                MsgBox('Submit either "left" or "right"')
                return
            }
        }
    }
    textColor
    {
        get {
            return this.textColor
        }
        set(value) {
            if (StrLen(value) != 6) {
                MsgBox("Color must be an RGB hex value")
                return
            }
            this.textColor := value
        }
    }
    padding
    {
        get {
            return this.padding
        }
        set(value) {
            if (ValidateInteger(value, 1, 10)) {
            this.padding := value
            }
        }
    }
    backgroundColor {
        get {
            return this.backgroundColor
        }
        set(value) {
            if (StrLen(value) != 6) {
                MsgBox("Color must be an RGB hex value")
                return
            }
            this.backgroundColor := value
        }
    }
}

class cTab extends cBase
{
    __New(name)
    {
        oSet := OpenSettings()
        if (InStr(oSet.Read, "`n" . name . " {", 1)) {
            MsgBox("That name already exists, please use a different name.")
            return
        }
        oSet.Close()
        this.name := name
    }
    __Delete()
    {
        DllCall("GlobalFree", "Ptr", this.ptr)
    }
    __Set(name, params, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
    __Get(name, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
    buttons
    {
        get {
            return this.buttons
        }
        set(value) {
            this.buttons := value
        }
    }
}

class cWindow
{
    __New()
    {
        oSet := OpenSettings()
        aObjStrings := GetSettingsArray(oSet.Read())
        oSet.Close()
        oWindow := {}
        Loop aObjStrings.length {
            tabText := aObjStrings[A_Index]
            tabName := SubStr(tabText, 1, InStr(tabText, "{") - 2)
            if (StrLower(tabName) = "global") {
                CreateGlobalObj(tabText)
                continue
            }
            this.%tabName% := cTab(tabName)
            sA := RemoveButtonsFromString(GetObjectText(tabText))
            aSubTabText := StrSplit(sA[1], "`n")
            Loop aSubTabText.length
            {
                key := TrimAll(SubStr(aSubTabText[A_Index], 1, InStr(aSubTabText[A_Index], " : ") - 1))
                value := TrimAll(SubStr(aSubTabText[A_Index], InStr(aSubTabText[A_Index], " : ") + 3))
                this.%tabName%.%key% := value
            }
            bA := StrSplit(GetObjectText(sA[2]))
            this.%tabName%.buttons := {}
            Loop bA.length {
                key := TrimAll(SubStr(bA[A_Index], 1, InStr(bA[A_Index], " : ") - 1))
                value := TrimAll(SubStr(bA[A_Index], InStr(bA[A_Index], " : ") + 3))
                this.%tabName%.buttons.%key% := value
            }
        }
    }
    __Delete()
    {
        DllCall("GlobalFree", "Ptr", this.ptr)
    }
    __Set(name, params, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
    __Get(name, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
}

class cGlobal extends cBase
{
    __New(gText)
    {
        aGText := StrSplit(gText, "`n")
        Loop aGText.length {
            key := TrimAll(SubStr(aGText[A_Index], 1, InStr(aGText[A_Index], " : ") - 1))
            value := TrimAll(SubStr(aGText[A_Index], InStr(aGText[A_Index], " : ") + 3))
            this.%key% := value
        }
    }
    __Delete()
    {
        DllCall("GlobalFree", "Ptr", this.ptr)
    }
    __Set(name, params, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
    __Get(name, value)
    {
        MsgBox("That is not a valid property.")
        return
    }
    mouseXOffset { 
        get {
            return this.mouseXOffset
        }
        set(value) {
            if (ValidateInteger(value, 0, 2000)) {
                this.mouseXOffset := value
            } else {
                MsgBox("Mouse X offset must be an integer between 0 and 2000")
                return
            }
        }
    }
    mouseYOffset { 
        get {
            return this.mouseYOffset
        }
        set(value) {
            if (ValidateInteger(value, 0, 2000)) {
                this.mouseYOffset := value
            } else {
                MsgBox("Mouse Y offset must be an integer between 0 and 2000")
                return
            }
        }
    }
    windowWidth {
        get {
            return this.windowWidth
        }
        set(value) {
            if (ValidateInteger(value, 200, 2000)) {
                this.windowWidth := value
            } else {
                MsgBox("Window width must be an integer between 200 and 2000")
                return
            }
        }
    }
    windowHeight {
        get {
            return this.windowHeight
        }
        set(value) {
            if (ValidateInteger(value, 200, 2000)) {
                this.windowHeight := value
            } else {
                MsgBox("Window height must be an integer between 200 and 2000")
                return
            }
        }
    }
    windowTitle {
        get {
            return this.windowTitle
        }
        set(value) {
            this.windowTitle := value
        }
    }
    settingsPath {
        get {
            return this.settingsPath
        }
        set(value) {
            this.settingsPath := value
        }
    }
    chromePath {
        get {
            return this.chromePath
        }
        set(value) {
            this.chromePath := value
        }
    }
    fontSize {
        get {
            return this.fontSize
        }
        set(value) {
            if (ValidateInteger(value, 6, 26)) {
                this.fontSize := value
            } else {
                MsgBox("Font size must be an integer between 6 and 26")
                return
            }
        }
    }
    fontQuality {
        if (ValidateInteger(value, 1, 5)) {
            this.fontQuality := value
        } else {
            MsgBox("Font quality must be an integer between 1 and 5")
            return
        }
    }
    fontName {
        get {
            return this.fontName
        }
        set(value) {
            this.fontName := value
        }
    }
}

settingsPath := "settings.txt"

; GUI settings
nY := 0
nX := 0
hwnd := ""
myGui := Gui("+MinSize600x400 +MaxSize900x600 +Resize -MaximizeBox", gTitle)

; Menu bar
fileMenu := Menu()
fileMenu.Add "&Open", (*) => FileSelect()
fileMenu.Add "New category", NewCategory
fileMenu.Add "New template", NewTemplate
fileMenu.Add "New link", NewLink
fileMenu.Add "Edit", EditControls
fileMenu.Add "Delete", DeleteControls
fileMenu.Add "Display shortcuts", DisplayShortcuts
fileMenu.Add "Exit", (*) => ExitApp()
gMenuBar := MenuBar()
gMenuBar.Add "&File", fileMenu
myGui.MenuBar := gMenuBar

myGui.Add("Tab3", "w730 h480 xm10 ym5", ["Primary", "General", "Email", "Credible", "Portal", "Other"])

!t::
{
    ShowGui()
}

ShowGui()
{
    global
    hwnd
    nX
    nY
    nW
    nH
    gTitle
    MouseGetPos(&nMx, &nMy)
    nX := nMx + xOffset
    nY := nMy + yOffset
    myGui.Show("x" nX " y" nY " w" nW " h" nH)
    WinWait(gTitle)
    hwnd := WinGetID(gTitle)
}

NewCategory(*)
{
    MsgBox("New category")
    return
}

NewTemplate(*)
{
    global settingsPath
    oSet := OpenSettings()
    oGset := GetSettingsObj(oSet)
    oSet.Close()
    c := 0
    templateName := ""
    while (!templateName && c <= 10) {
        c++
        templateName := InputBox("Enter the name of the new template", "New Template")
    }
    if (!templateName) {
        return
    }
    templateString := ""
    c := 0
    while (!templateString && c <= 10) {
        c++
        templateString := InputBox("Enter the template string", "New Template")
    }
    if (!templateString) {
        return
    }
    oSet := FileOpen(settingsPath, "w")
    newKey := "btn" templateName
    newValue := templateString
    
    AddToSettings(newKey, newValue, oSet, tabName)

}

NewLink(*)
{
    MsgBox("New link")
    return
}

EditControls(*)
{
    MsgBox("Edit controls")
    return
}

DeleteControls(*)
{
    MsgBox("Delete controls")
    return
}

DisplayShortcuts(*)
{
    MsgBox("Display shortcuts")
    return
}

!WheelDown::
{
    if (hwnd && WinActive(hwnd)) {
        Send "^+{Tab}"
    } else {
        Send "!{WheelDown}"
    }
}

!WheelUp::
{
    if (hwnd && WinActive(hwnd)) {
        Send "^{Tab}"
    } else {
        Send "!{WheelUp}"
    }
}

OpenSettings()
{
    global settingsPath
    try {
        oSet := FileOpen(settingsPath, "rw")
    } catch Error as err {
        MsgBox("Error: " err.Message)
        return
    }
    if (oSet) {
        return OSet
    } else {
        return ""
    }
}
AddToSettings(key, newValue, oSet, tabName, delim := " : ")
{
    text := oSet.Read()
    startPos := InStr(text, tabName " {")
    endPos := InStr(text, "}", startPos)
    sText := SubStr(text, startPos, endPos - startPos)
    sPartOne := SubStr(text, 1, startPos - 1)
    sPartTwo := SubStr(text, endPos + 1)
    sText := StrReplace(sText, "}", key delim newValue "`n}")
    text := sPartOne sText sPartTwo
    oSet.Seek(0)
    oSet.Write(text)
    oSet.Close()
    return
}
GetSettingsArray(settingsText)
{
    regexStr := "(?<=\R)[a-zA-Z]"
    subText := text
    aObjStrings := []
    while (pos := RegExMatch(subText, regexStr, match)) {
        closePos := InStr(subText, "`n}", pos) + 1
        tabText := SubStr(subText, pos, closePos - pos)
        subText := SubStr(subText, closePos + 2)
        aObjStrings.Push(tabText)
        pos := RegExMatch(subText, regexStr, match)
    }
    return aObjStrings
}
WriteNewValue(key, newValue, oldValue, sText, delim := " : ")
{
    newLine := key delim newValue
    oldLine := key delim oldValue
    sText := StrReplace(sText, oldLine, newLine)
    return sText
}
UpdateSettings(key, newValue, oldValue)
{
    global settingsPath
    oSet := OpenSettings()
    text := oSet.Read()
    text := WriteNewValue(key, newValue, oldValue, text)
    if (oSet) {
        text := oSet.Read()
        oSet.Seek(0)
        oSet.Write(text)
        oSet.Close()
    }
}
RemoveButtonsFromString(settingsText)
{
    btnPos := InStr(settingsText, "butons : {")
    closePos := InStr(settingsText, "}", btnPos)
    sPartOne := TrimAll(SubStr(settingsText, 1, btnPos - 2))
    sPartTwo := TrimAll(SubStr(settingsText, closePos + 2))
    settingsText := sPartOne sPartTwo
    btnText := TrimAll(SubStr(settingsText, btnPos, closePos - btnPos))
    rA := [settingsText, btnText]
    return rA
}
GetObjectText(text)
{
    startPos := InStr(text, "{") + 2
    endPos := InStr(text, "`n}") - 1
    subText := SubStr(text, startPos, endPos - startPos)
    return subText
}

ValidateInteger10to100(num)
{
    if (!ValidateInteger(num, 10, 100)) {
        MsgBox(Width and height must be an integer between 10 and 100")
        return false
    }
    return true
}
ValidateInteger(num, minInclusive, maxInclusive)
{
    if (!IsNumber(num) || num <= minInclusive || num >= maxInclusive) {
        return false
    }
    return true
}
TrimAll(s)
{
    return RegExReplace(s, "^\s+|\s+$")
}
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

