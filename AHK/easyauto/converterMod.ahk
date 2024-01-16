﻿modifyAhkv2ConverterOutput(FNOut := "path", script := "code") ;outscript_path
{
    GuiControlVars := []
    , GuiControlVars.Push(Map("item", "Button", "event", "Click", "function", "Text"))
    , GuiControlVars.Push(Map("item", "DropDownList", "event", "Change", "function", "Text"))
    , GuiControlVars.Push(Map("item", "Edit", "event", "Change", "function", "Value"))
    , GuiControlVars.Push(Map("item", "DateTime", "event", "Change", "function", "Value"))
    , GuiControlVars.Push(Map("item", "MonthCal", "event", "Change", "function", "Value"))
    , GuiControlVars.Push(Map("item", "Radio", "event", "Click", "function", "Value"))
    , GuiControlVars.Push(Map("item", "CheckBox", "event", "Click", "function", "Value"))
    , GuiControlVars.Push(Map("item", "ComboBox", "event", "Change", "function", "Text"))
    eventList := []
    GuiItemCounter := [1, 1, 1, 1, 1, 1, 1, 1]
    brackets := 0
    ; RemoveFunction==1 loops to find `{}` while `{}` not found in line
    new_outscript := ""
    buttonFound := 0, itemFound := 0, editCount := 0, menuHandler := 0, guiShow := 0, RemoveFunction := 0, menuHandle := 0, GuiEsc := 0, FindMenu := 0, FindMenuBar := 0, MenuHandleCount := 0, ctrlcolor := 0
    guiname := "", title := "",  GuiItem_Storage := [],  Edit_Storage := [],  GuiCtrlStorage := []
    if FileExist(FNOut) {
        FileMove(FNOut, A_ScriptDir "\required\convert\temp.txt", 1)
    }
    Loop Parse, script, "`n", "`r"
    {
        TrimmedField := Trim(A_LoopField)
        new_outscript := ((A_Index = 1) && not InStr(A_LoopField, "#Requires Autohotkey v2"))
            ? "`n#Requires Autohotkey v2`n;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901`n;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter`n;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2`n`n"
            : new_outscript
        if (RemoveFunction = 1) {
            hasOpeningBracket := InStr(TrimmedField, "{")
            hasClosingBracket := InStr(TrimmedField, "}")

            if (hasOpeningBracket && !hasClosingBracket) {
                brackets += 1
            }
            else if (!hasOpeningBracket && InStr(A_LoopField, "}")) {
                brackets := (brackets > 1) ? brackets - 1 : 0
                RemoveFunction := brackets = 0 ? 0 : RemoveFunction ; Conditional assignment
            }
            else {
                continue
            }
        }
        if (guiname = "") && InStr(A_LoopField, " := Gui()") {
            guiname := StrSplit(A_LoopField, " := Gui()")[1]
            new_outscript .= A_LoopField "`n"
            continue
        }
        ; =================== check for gui items ======================= 
        if InStr(A_LoopField, "Add(") {
            ret := checkforGuiItems(A_LoopField, &GuiControlVars, &GuiItemCounter, &GuiCtrlStorage)
            ; ; loop through and look for GuiControlVars[]
            if (ret[1] = 1) {
                ;button
                itemFound := 1
                lastGuiControl := ret[2]
                oldvar := StrSplit(A_LoopField, " := ")[1]
                newline := StrReplace(A_LoopField, oldvar, ret[2])
                new_outscript .= newline "`n"
                continue
            }
            if (ret[1] = 2) {
                new_outscript .= ret[2] " := " A_LoopField "`n"
                lastGuiControl := ret[2]
                itemFound := 1
                continue
            }
            else {
                lastGuiControl := StrSplit(A_LoopField, " := ")
            }
        }
        ; =================== check for gui items =======================
        if InStr(A_LoopField, ".Title :=") {
            title := A_LoopField
            continue
        }
        else if (menuHandle = 0) && (MenuHandleCount < 1) && InStr(A_LoopField, "MenuHandler") {
            ; if MenuHandler is found, add a function at the bottom of the app to handle
            menuHandle := 1
            new_outscript .= A_LoopField . "`n"
        }
        else if InStr(A_LoopField, "MenuHandler(") {
            MenuHandleCount += 1
            RemoveFunction := 1
        }
        ; else if InStr(A_LoopField, ".Add(`"Button`"") {
        ;     buttonFound := 1
        ;     new_outscript .= A_LoopField "`n"
        ;     variableName := Trim(StrSplit(A_LoopField, ":=")[1])
        ;     ;ogcButtonOK.OnEvent("Click", GuiClose)
        ;     val := variableName ".OnEvent(`"Click`", OnEventHandler)`n"
        ;     new_outscript .= val
        ; }
        else if InStr(A_LoopField, "GuiEscape(*)") && (menuHandler = 0) {
            menuHandler := 1
            ;if END OF SCRIPT found, attempt to append functions
            ;Function MenuHandler or OnEventHandler
            ;provide tooltips when buttons are clicked or values are entered
            if (menuHandle = 1) && (MenuHandleCount < 2) {
                new_outscript .= "`nMenuHandler(*)`n" tooltip_()
                GuiEsc := 1
            }
            if (itemFound = 1) {
                func := "`nOnEventHandler(*)`n"
                string := ""
                event_control_tooltips := ""
                for ctrl in GuiCtrlStorage {
                    event_control_tooltips .= Format(" `n`t. `"{1} => `" {1}.{2} `"``n`"", ctrl.name, ctrl.function)
                }
                if (event_control_tooltips != "") {
                    new_outscript .= func . tooltip_(event_control_tooltips)
                }
                else {
                    new_outscript .= func . tooltip_()
                }
            }
            break
            ;if ()    GuiEsc := 1
        }
        else if (menuHandle = 1) && (MenuHandleCount >= 1) && InStr(A_LoopField, "MenuHandler(") {
            ;remove default menuhandler function
            RemoveFunction := 1
            continue
        }
        else if InStr(A_LoopField, "OnEvent(`"Close`", GuiEscape)") || InStr(A_LoopField, "OnEvent(`"Escape`", GuiEscape)") || InStr(A_LoopField, "Bind(`"Normal`")") || (A_LoopField = "") || InStr(A_LoopField, ".SetFont()") || InStr(A_LoopField, ".hwnd") || InStr(A_LoopField, "+hWnd") {
            ;remove all if cases
            continue
        }
        
        else if (Trim(A_LoopField = "Return") || Trim(A_LoopField = "return")) {
            continue
        }
        else if InStr(A_LoopField, "ControlColor(") {
            ctrlcolor := 1
            RegExMatch(A_LoopField, "0x[a-fA-F0-9]{6}", &match)
            if IsObject(match) {
                hex := match[0]
                if InStr(hex, "0x") {
                    hex := StrReplace(hex, "0x", "")
                }
                new_outscript .= lastGuiControl ".Opt(`"Background" hex "`")"
                new_outscript .= "`n"
            }
        }
        else if (TrimmedField = "Menu := Menu()") {
            ;fix naming convension of Menu
            new_outscript .= StrReplace(A_LoopField, "Menu := Menu()", "Menu_Storage := Menu()")
            new_outscript .= "`n"
            FindMenu := 1
        }
        else if InStr(TrimmedField, ".New(") {
            ;fix naming convension of Menu
            new_outscript .= StrReplace(A_LoopField, ".New(", ".Opt(")
            new_outscript .= "`n"
            Continue
        }
        else if (FindMenu = 1) && (InStr(TrimmedField, "Menu.Add(")) {
            ;fix naming convension of Menu
            if (StrSplit(TrimmedField, "(")[1] = "Menu.Add") {
                new_outscript .= StrReplace(A_LoopField, "Menu.Add(", "Menu_Storage.Add(") "`n"
            }
        }
        else if (TrimmedField = "MenuBar := Menu()") {
            ;fix naming convension of MenuBar
            new_outscript .= StrReplace(A_LoopField, "MenuBar := Menu()", "MenuBar_Storage := MenuBar()") "`n"
            FindMenuBar := 1
        }
        else if (FindMenuBar = 1) && InStr(TrimmedField, "MenuBar.Add(") {
            if (StrSplit(TrimmedField, "(")[1] = "MenuBar.Add") {
                new_outscript .= StrReplace(A_LoopField, "MenuBar.Add(", "MenuBar_Storage.Add(") "`n"
            }
        }
        else if InStr(A_LoopField, ".MenuToolbar := MenuBar") {
            ;fix naming convension of MenuToolbar
            new_outscript .= StrReplace(A_LoopField, "MenuToolbar := MenuBar", "MenuBar := MenuBar_Storage") . "`n"
        }
        else if InStr(A_LoopField, ".Show(`"") && (guiShow = 0) {
            guiShow := 1
            ;look for line before `return` (GuiShow)
            ;if found, and NO [submit] button is used
            ;user will get tooltips on value changes
            ;instead of submittion
            if (itemFound = 1)
            {
                eventsStringified := []
                for ctrl in GuiCtrlStorage {
                    skip := false
                    ; ctrl.event := eventList[A_Index]
                    if eventsStringified.Length > 0 {
                        for eventstr in eventsStringified {
                            if ctrl.name = eventstr {
                                skip := true
                            }
                        }
                    }
                    if skip = false {
                        eventsStringified.Push(ctrl.name)
                        new_outscript .= ctrl.name ".OnEvent(`"" ctrl.event "`", OnEventHandler)`n"
                    }
                }
            }
            new_outscript .= guiname ".OnEvent('Close', (*) => ExitApp())`n" title . "`n" A_LoopField . "`n"
        }
        else {
            new_outscript .= A_LoopField . "`n"
        }
    }
    new_outscript := InStr(new_outscript, "ListviewListview") ? new_outscript := StrReplace(new_outscript, "ListviewListview", "_Listview") : new_outscript
    InStr(new_outscript, "ogc") ? new_outscript := StrReplace(new_outscript, "ogc", "") : new_outscript := new_outscript
    return new_outscript
}
checkforGuiItems(LoopField, &GuiControlVars, &GuiItemCounter, &GuiCtrlStorage) {
    for index, ctrl in GuiControlVars
    {
        if InStr(LoopField, Format(".Add(`"{1}`"", ctrl["item"]))
        {
            var := (InStr(LoopField, " := ")) ? StrSplit(LoopField, " := ")[1]
                : ctrl["item"] GuiItemCounter[index]
            var := (IsAlpha(var) || IsAlnum(var)) ? var : cleanAlpha(var) GuiItemCounter[index]
            (InStr(LoopField, " := ")) ? GuiCtrlStorage.Push({ name : var, event: ctrl["event"], function: ctrl["function"]})
        : GuiItemCounter[index] += 1
        return [InStr(LoopField, " := ") ? 1: 2, var]
        }
    }
    return [0]
}


tooltip_(string := "") {
    if (string != "") {
        string := "`n`t. `"Active GUI element values include:``n`" " . string
    }
    return "{`n`tToolTip(`"Click! This is a sample action.``n`"" string ", 77, 277)`n`tSetTimer () => ToolTip(), -3000 `; tooltip timer`n}`n"
}

cleanAlpha(StrIn) {
    len := StrLen(StrIn)
    newVar := ""
    loop len {
        char := SubStr(StrIn, A_Index, 1)
        if IsAlpha(char) {
            newVar .= char
        }
    }
    return newVar
}
