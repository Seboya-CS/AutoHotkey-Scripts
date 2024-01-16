; Initialize the script
#Warn
SendMode Input
templateFilePath := "C:\Users\westn\OneDrive\OneDrive\all documents\Github repositories\Seboya\AutoHotkey-Scripts\AHK\Scripts\logs\templates.txt" ; Change this to your desired file path

; Define a hotkey to show the GUI, for example, Ctrl+Shift+T
^+T::ShowGUI()

; Function to show the GUI
ShowGUI() {
    Gui := GuiCreate("Template Keeper") ; Create a new GUI window
    LoadTemplates(Gui) ; Load templates from file

    ; Add controls to the GUI
    Gui.Add("ListBox", "vTemplateList w300 h200", "")
    Gui.Add("Edit", "vNewTemplate w300 h50")
    Gui.Add("Button", "gSaveTemplate", "Save")
    Gui.Add("Button", "gDeleteTemplate", "Delete")
    Gui.Add("Button", "gSetClipboard", "Set to Clipboard")
    Gui.Add("Button", "gAddNewTemplate", "Add New Template")
    Gui.Add("Button", "gExitGui", "Exit")

    ; Show the GUI
    Gui.Show("w400 h300")
    return
}

; Function to load templates from file
LoadTemplates(Gui) {
    FileRead(templates, templateFilePath)
    GuiControl := Gui.GetControl("TemplateList")
    GuiControl.Choices := templates
}

SaveTemplate:
    Gui.Submit("NoHide")
    newTemplate := NewTemplate
    if (newTemplate != "") {
        FileAppend(newTemplate "`n", templateFilePath)
        LoadTemplates(Gui) ; Refresh the list box
    }
return

DeleteTemplate:
    ; Function to delete the selected template
    ; [Add logic to remove the selected template from the file and refresh the list box]
return

; ... [rest of your script] ...
