#SingleInstance force
#Requires AutoHotkey v2.0-a
#Include "C:\Users\westn\OneDrive\OneDrive\all documents\Github repositories\Powershell_scripts\AutoHotkey-Scripts\AHK\Scripts\Functions\array_n.ahk"

; Get script parameters from arguments
xlPath := A_Args[1]
xlSheet := A_Args[2]
logPath := A_Args[3]
workingDir := A_Args[4]
startRow := A_Args[5]
endRow := A_Args[6]
startCol := A_Args[7]
endCol := A_Args[8]


; ==============  INITIALIZATION  ===============================================================
; ===============================================================================================
; Check if the arguments are provided
if A_Args.Length() < 8 {
    MsgBox("Please provide the required arguments (xlPath, xlSheet, logPath, workingDir"
    , "startRow, endRow, startCol, endCol).")
    ExitApp
}

; Set working directory
SetWorkingDir workingDir

; Initialize variables
noLogBool := false
logOpenBool := false
firstPassBool := true

; Determine number of columns and rows, to allow standardization to an array with
; a lower bound of 1.
nRow := endRow - startRow + 1
nCol := endCol - startCol + 1

; ==============  INITIALIZE LOG  ===============================================================
; ===============================================================================================
; Ensure the log is writeable
InitializeLog(callPrc := "") {
    try {
        logFile := FileOpen(logPath, "a")
        if !logFile {
            throw "Unable to open file"
        }
    }
    catch as err {
        iB.result := InputBox("There was an error accessing the log. Attempt to create a new one?"
            , "Error 001", "No")
        if iB.result = "Yes" {
            try {
                logFile := FileOpen(logPath, "rw")
                if !logFile {
                    throw "Unable to create file"
                }
                catch as err {
                    MsgBox("Unable to create log file. Please check the file path and directory" & 
                            , permissions. Exiting the script.")
                    ExitApp
                }
                Else { 
                    MsgBox("Log file created successfully.")
                }
            } Else {
                iB.result := InputBox("Proceed without logging?", "Error 001", "Yes", "No", "No")
                if iB.result = "Yes" {
                    noLogBool := true
                    return 0
                } Else {
                    MsgBox("Exiting the script.")
                    ExitApp
                }
            }
        } Else {
            if firstPassBool {
                logFile.Write("First pass initialization success: " A_Now "`r`n")
                firstPasBool := false
            } Else {
                logFile.Write("Calling procedure: " callPrc ". Process initialization: " A_Now "`r`n")
            }
        }
    }
    logOpenBool := true
    return 1
}

; ==============  FUNCTIONS =====================================================================
; ===============================================================================================

;--------------------------------------------------------------------------------------------------
;-------------||__Copy array to file__||-----------------------------------------------------------
CopyArray(array, callPrc := "") {
    If noLogBool {
        return
    }
    Else if !logOpenBool{
        InitializeLog("CopyArray")
    }
    if !noLogBool {
        try {
            logFile.Write("Calling procedure: " callPrc ". Copying array to file: " A_Now "`r`n"
            , "Array dimensions: Rows: " nRow ". Columns: " nCol ". `r`n")
            for nRow, nCol, value in array {
                file.Write("[" nRow "] [" nCol "] : " value  "`r`n")
            }
        }
        Catch as err {
            MsgBox "(Error 002. There was an error copying the 
                array to file. Logging is disbaled until retart.)"
            noLogBool := true
        }
    } 
    return
}
ClearArray(array) {
    array := []
    return array
}
;-------------||^ Copy array to file ^||---------------------------------------------------------
;------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------
;-------------||__Generate array__||---------------------------------------------------------
; Determine number of columns and rows, to allow standardization to an array with
; a lower bound of 1.
; nRow := endRow - startRow + 1
; nCol := endCol - startCol + 1

; Call the function to create an array
xlArray := array_n(nRow, nCol)
!b::
{


;-------------||^ Generate array ^||-------------------------------------------------------------
;------------------------------------------------------------------------------------------------


ListVars
Pause
        
        ; Initialize Excel COM object (or connect to an existing one)
        xl := ComObjCreate("Excel.Application") ; or ComObjActive("Excel.Application") to attach
                                 ; to an existing instance
        xl.Visible := false
ListVars
Pause    
        ; Open the Excel workbook
        xl.Workbooks.Open(xlPath)
ListVars
Pause    
        ; Iterate from 1 to numCols
        For k, value in Range(1, numCols)
        {
            ; Create a new array (sub-object) for each key
            arrays[k] := []
        
            ; Loop for Excel cells
            for cells in xl.Sheets(xlSheet).Range("Cells(" startRow ", " startCol + k - 1 "):Cells(" endRow ", " startCol + k - 1 ")")
                arrays[k].Push(cells.Value)
ListVars
Pause    
        }
        
        ; Function to generate a range of numbers (inclusive)
        Range(start, end) {
            range := []
            Loop, % end - start + 1
                range.Push(start + A_Index - 1)
            return range
        }
        
}
    


; Error codes
; 001 - Unable to initialize log
; 002 - Unable to copy array to file
