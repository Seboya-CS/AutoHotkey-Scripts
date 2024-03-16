
#SingleInstance force
SetWorkingDir A_ScriptDir                                                       ; ensures a consistent starting directory.

global myGui, filesObj

^!m::ShowMoveGUI()                                                              ; Ctrl+Alt+M to show GUI

ShowMoveGUI() {                                                                 
    global myGui, filesObj
    try {                                                                       ; try to get the selected files as 
        filesObj := GetSelectedFilePaths()                                          ; COM object
    } catch Error as err {                                                      ; catch any errors
        MsgBox("Error: " . err.Message)                                         ; show an error message
        return
    }
    
    if (filesObj.Count = 0) {                                                   ; if no files are selected
        MsgBox("No file selected!")                                             ; show a message
        return
    }

    ; GUI Setup - add buttons
    myGui := Gui("+Resize", "File Move")
    btn1 := myGui.Add("Button", "w50 h20 x5 y5", "1")
    btn2 := myGui.Add("Button", "w50 h20 x5 y+5", "2")

    ; GUI Setup - add labels
    lbl1 := myGui.Add("Text", "h20 x60 y5", "PA archive")
    lbl2 := myGui.Add("Text", "h20 x60 y+5", "General archive")

    ; GUI Setup - add event handlers
    btn1.OnEvent("Click", btn1_Click)
    btn2.OnEvent("Click", btn2_Click) 

    ; GUI Setup - show the GUI
    myGui.Show
}

btn1_Click(btn1, info) {
    MoveToFolder("C:\Users\westn\OneDrive\OneDrive\Desktop\test1\")              ; move to the PA archive folder
}

btn2_Click(btn2, info) {
    MoveToFolder("C:\Users\westn\OneDrive\OneDrive\Desktop\test2\")              ; move to the General archive folder
}

MoveToFolder(targetFolder) {
    global myGui, filesObj
    try {
        for file in filesObj {                                                  ; loop through the selected filesObj
            targetPath := GetTargetPath(file, targetFolder)                     ; get the target path
            FileMove(file.Path, targetPath)                                     ; move each file to the target folder
        }
    } catch Error as err {                                                      ; catch any errors
        ErrorHandler(err)                                                       ; handle the error
}
    myGui.Destroy                                                                 ; close the GUI
    return
}

GetTargetPath(file, targetFolder) {
    fileSplit := StrSplit(file.Path, "\")                                       ; split the file path
    fileName := fileSplit[fileSplit.Length]                                     ; get the file name
    targetPath := CheckIfFileExists(targetFolder, fileName)                      ; create the target path
    return targetPath                                                           ; return the target path
}

CheckIfFileExists(targetFolder, fileName) {
    c := 0                                                                      ; set a counter
    targetFolder := CheckForTrailingBackslash(targetFolder)                     ; check for a trailing backslash
    targetPath := targetFolder fileName                                         ; create the target path
    while (FileExist(targetPath) && c <= 10) {                                  ; if the file already exists
        c++                                                                     ; increment the counter
        response := MsgBox("File already exists: " targetPath "\n"
            "Do you want to rename the file?", , 3)                             ; ask the user what to do
        if (response = "Yes") {                                                 ; if the user wants to rename the file
            inputObj := InputBox("Enter a new name for the file:", 
                "Rename File", , targetPath)                                    ; get a new name
            if (inputObj.Result = "Cancel") {                                   ; if the user cancels
                throw Error("Operation cancelled by user.")                     ; throw an error
            } else if (!ValidateFileName(inputObj.value)) {                     ; if the file name is invalid
                MsgBox("Invalid file name.")                                    ; show a message
            } else {
                targetPath := inputObj.value 
            }
        } else if (response = "No") {                                           ; if the user doesn't want to rename the file
            targetPath := file.path                                             ; don't move the file
            Break                                                               ; Break the loop
        } else if (response = "Cancel") {
            throw Error("Operation cancelled by user.")                         ; throw an error
        }
    }
    if (c > 10) {
        throw Error("Too many attempts. Please review.")                        ; throw an error
    } else {
        return targetPath                                                       ; return the target path
    }
}

GetSelectedFilePaths() {                                                        ; using COM to interact with File Explorer
    shellWindows := ComObject("Shell.Application").Windows()                    ; get the open windows
    for window in shellWindows {                                                ; loop through the open windows
        if (InStr(window.FullName, "explorer.exe")) {                           ; if the window is an Explorer window
            try {                                                               ; try to get the selected items
                selectedItems := window.Document.SelectedItems()                ; get the selected items
                if (selectedItems.Count > 0) {                                  ; if items are selected
                    return selectedItems                                        ; Return an array of selected file paths
                }
            } catch Error as err {                                              ; catch any errors
                throw Error(err)                                                ; throw the error
            }
        }
    }
    throw Error("An unexpected exception occurred. Please review.")             ; throw error
}

ValidateFileName(fileName) {
    if (RegExMatch(fileName, '/:\*\?"<>\|') || fileName = "") {                 ; if the file name contains invalid characters
        return false                                                            ; return false
    } else if (RegExMatch(fileName, '[a-zA-Z]:')) {                             ; if the file name contains a drive letter
        return true                                                             ; return true
    } else {
        return false                                                            ; return false
    }
}

CheckForTrailingBackslash(path) {
    if (SubStr(path, -1) != "\") {                                              ; if the path doesn't end with a backslash
        path .= "\"                                                             ; add a backslash
    }
    return path                                                                 ; return the path
}

ErrorHandler(err) {
    errorMsg := "Error: " . err.Message                                         ; create an error message
    if (err.HasOwnProp("What")) {                                               ; if the error has a what property
        errorMsg .= "`nWhat: " err.What                                         ; add the what to the error message
    }
    if (err.HasOwnProp("File")) {                                               ; if the error has a file property
        errorMsg .= "`nFile: " err.File                                         ; add the file to the error message
    }
    if (err.HasOwnProp("Line")) {                                               ; if the error has a line property
        errorMsg .= "`nLine: " err.Line                                         ; add the line to the error message
    }
    if (err.HasOwnProp("Extra")) {                                              ; if the error has an extra property
        errorMsg .= "`nExtra: " err.Extra                                       ; add the extra to the error message
    }
    MsgBox(errorMsg)                                                            ; show the error message
    return
}

; Close the GUI when Esc is pressed
Escape:: {
    global myGui
    if (myGui) {
        myGui.Destroy
    }
    return
}
