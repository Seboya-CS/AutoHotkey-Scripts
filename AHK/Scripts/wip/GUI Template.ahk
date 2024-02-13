
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
myGui.BackColor := "0x8000FF"
myGui.SetFont("s12 Norm c0xFFFFFF", "Calibri")
EditvTxtSubmitTo := myGui.Add("Edit", "vvTxtSubmitTo x8 y32 w200 h137 +Multi", "`"C:\Users\nmw59\Downloads\Compressed\AutoHotkey_2.0.11\Easy-Auto-GUI-v1.7-for-AHK-v2.2.1\README.md`"")
EditvTxtSubmitTo.Opt("Background3C003C")
myGui.Add("ListBox", "x8 y432 w133 h69", ["ListBox"])
CheckBox1 := myGui.Add("CheckBox", "x8 y408 w72 h23", "CheckBox")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y264 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y288 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y312 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y336 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y360 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y384 w39 h23", "&OK")
Edit1 := myGui.Add("Edit", "x72 y264 w120 h21")
Edit2 := myGui.Add("Edit", "x72 y288 w120 h21")
Edit3 := myGui.Add("Edit", "x72 y312 w120 h21")
Edit4 := myGui.Add("Edit", "x72 y240 w120 h21")
Edit5 := myGui.Add("Edit", "x72 y336 w120 h21")
Edit6 := myGui.Add("Edit", "x72 y360 w120 h21")
Edit7 := myGui.Add("Edit", "x72 y384 w120 h21")
Radio1 := myGui.Add("Radio", "x216 y40 w21 h29")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y216 w39 h23", "&OK")
myGui.SetFont("s11 Norm cOlive", "Calibri")
ButtonOK := myGui.Add("Button", "x32 y240 w39 h23", "&OK")
Edit8 := myGui.Add("Edit", "x72 y216 w120 h21")
ButtonClear := myGui.Add("Button", "x16 y176 w50 h23", "Clear")
ButtonSubmit := myGui.Add("Button", "x80 y176 w50 h23", "Submit")
EditvTxtSubmitTo.OnEvent("Change", OnEventHandler)
ButtonOK.OnEvent("Click", OnEventHandler)
ButtonClear.OnEvent("Click", OnEventHandler)
ButtonSubmit.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "The Office Worker's Toolkit"
myGui.Show("w610 h515")
hToolbar := CreateToolbar()
CreateToolbar() {
    ImageList := IL_Create(3)
    IL_Add(ImageList, "shell32.dll", 327)
    IL_Add(ImageList, "shell32.dll", 22)
    Buttons := "
    (LTrim
        -
        File
        Tools,,, DROPDOWN
    )"
    Return ToolbarCreate("OnToolbar", Buttons, ImageList, "Flat List ShowText Tooltips")
}
OnToolbar(hWnd, Event, Text, Pos, Id) {
    If (Event != "Click") {
        Return
    } Else If (Text == "File") {
    } Else If (Text == "Tools") {
    }
}
