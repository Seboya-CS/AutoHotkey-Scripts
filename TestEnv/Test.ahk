#SingleInstance force
#Requires AutoHotkey v2.0-a

; Get script parameters from arguments
xlPath := A_Args[1]
xlSheet := A_Args[2]
logPath := A_Args[3] 
workingDir := A_Args[4]
startRow := A_Args[5]
endRow := A_Args[6]
startCol := A_Args[7]
endCol := A_Args[8]
xlTextFiles := A_Args[9] ; Comma-delimited list of paths for the text files that the table will be recorded to

; ~~~++++++++++++++++++++++++++
; 					Error codes								;++
; 001 - Unable to initialize log					;++
; 002 - Unable to copy array to file			;++

; ~~~++++++++++++++++++++++++;+


; ============== INITIALIZATION  ====================================================================
; =================================================================================================
; Check if the arguments are provided
if A_Args.capacity < 9 {
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
notifyGroupID := ""

; Determine number of columns and rows, to allow standardization to an array with
; a lower bound of 1.
nRow := endRow - startRow + 1
nCol := endCol - startCol + 1

; Turn the comma-delimited list of paths into an array
xlPathArray := StrSplit(xlTextFiles, ",")

; ==============  INITIALIZE LOG  ====================================================================
; =================================================================================================
InitializeLog(callingProcedure := "") {    	; The callingProcedure optional variable is for debugging
    try {																; So I know what procedure called this procedure
        logFile := FileOpen(logPath, "a")
        if !logFile {
            throw "Unable to open file"
        }
    }
    catch as err {
        result := InputBox("There was an error accessing the log. Attempt to create a new one?"
            , "Error 001", "No")
        if result = "Yes" {
            try {
                logFile := FileOpen(logPath, "rw")
                if !logFile {
                    throw "Unable to create file"
                }
            }
            catch as err {
                MsgBox("Unable to create log file. Please check the file path and directory permissions. Exiting the script.")
                ExitApp
            }
            MsgBox("Log file created successfully.")
        } Else {
            result := InputBox("Proceed without logging?", "Error 001", "Yes" "No", "No")
            if result = "Yes" {
                noLogBool := true
                return 0
            } Else {
                MsgBox("Exiting the script.")
                ExitApp
            }
        }
    }
    if firstPassBool {
        logFile.Write("First pass initialization success: " A_Now "`r`n")
        firstPassBool := false
    } Else {
        logFile.Write("Calling procedure: " callingProcedure ". Process initialization: " A_Now "`r`n")
    }
    logOpenBool := true
    return 1
}

; =================================================================================================
; =============== MISCELLANEOUS FUNCTIONS ========================================================
; =================================================================================================

; -----------------------------------------------------------------------------------------------------------------
; ---------								Update notifyGroupID						-------------------------------
; -----------------------------------------------------------------------------------------------------------------

updateNotifyMsg(uChar, uRow, uUnchangedID)
{
	global notifyGroupID
	If (notifyGroupID= "")
	{
		notifyGroupID :=  uChar . " was removed from row " . row . " . Group ID: " . uUnchangedID
	} else {
		notifyGroupID := { 
										notifyGroupID . "; " . uChar . " was removed from row " . uRow . ". Group"
										" ID: " . uUnchangedID
		}
	}
	return
}
						

; =================================================================================================
; ============== FILE READING FUNCTIONS ============================================================
; =================================================================================================

;---------------------------------------------------------------------------------------------------------------
;-------------||__Copy array to file__||---------------------------------------------------------------
CopyArray(array, callingProcedure := "") {
    If noLogBool {
        return
    }
    Else if !logOpenBool{
        InitializeLog("CopyArray")
    }
    if !noLogBool {
        try {
            logFile := FileOpen(logPath, "a")
			logFile.Write("Calling procedure: " callingProcedure ". Copying array to file: " A_Now "`r`n"
            , "Array dimensions: Rows: " nRow ". Columns: " nCol ". `r`n")
            for nRow, nCol, value in array {
                file.Write("[" nRow "] [" nCol "] : " value  "`r`n")
            }
        }
        Catch as err {
            MsgBox ("Error 002. There was an error copying the array to file. Logging is disbaled until restart.")
            noLogBool := true
        }
    } 
    return
}

;-------------||^ Copy array to file ^||-----------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------
;         ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;---------------------------------------------------------------------------------------------------------------
;-------------||__Get worksheet info__||------------------------------------------------------------
!+s::
{ 
	global notifyGroupID
	
  ; Initialize Excel COM object (or connect to an existing one)
    xl := ComObject("Excel.Application") 		; Note: ComObject("Excel.Application") is used to initialize 
    xl.Visible := False											; a new instance of Excel, which is what we want in this
    wb := xl.workbooks.open(xlpath)				; case. For attaching to an existing Excel instance, use 
	ws := wb.worksheets(xlSheet)					; ComObjActive("Excel.Application")
    ws.activate
    ; Loop through each column
    Loop nCol
    {

        col := A_Index			; Essentially, col := the current value of nCol.
        columnData := ""		; Reset columnData
        Loop nRow		; Loop through every row in col
        {
; _________________________________________________________________________________________		
;                      ---------------------------         Explanation box         ---------------------------									||
;		In the next three lines, the script is being directed to read from the cells in the Excel		||
;		spreadsheet. In the first line, `row := A_Index` is not necessary, unlike the preceding 	||
;		`col := A_Index`. `A_Index` can only refer to the index value of a single loop, so for 		||
;		nested loops it refers to the Index value of the currently active loop. I'm storing its 		||
;		value into `row` simply for readability. In the second line, `ws.Cells` specifies what 		||
;		type of object is being referenced, in this case, the object is a cell, which is a 					||
;		"range" object in Microsoft's object model. `(row + startRow - 1, col + startCol -1)` 		||
;		is an expression used to specify which cell in the spreadsheet is being referenced. 		||
;		The format is (row, column). `row + startRow - 1` and `col + startCol - 1` are used to 	||
;		allow for flexibility. Even though we know the starting row and column of the Excel 	||
;		spreadsheet ahead of time, constructing the expression this way allows this script 		||
;		to be reusable for other purposes too.																							||
;                      ---------------------------          ---------------------------         ---------------------------									||
; _________________________________________________________________________________________								

            row := A_Index
			
            cellValue := ws.Cells(row + startRow - 1, col + startCol - 1).Value	
			firstChar := SubStr(cellValue, 1, 1)
			strL := StrLen(cellValue)
			lastChar := SubStr(cellValue, strL, 1)
			
			if (IsNumber(firstChar) = false)
			{
				tempStr := SubStr(cellValue, 2, strL - 1)
				strL := StrLen(tempStr)
				updateNotifyMsg(firstChar, row, cellValue)
			} else {
				tempStr := cellValue
			}
			
			if (IsNumber(lastChar) = false)
			{
				finalStr := SubStr(tempStr, 1, strL - 1)
				updateNotifyMsg(firstChar, row, cellValue)
			} else {
				finalStr := tempStr
			}
			
			
			
			
            columnData := columnData . cellValue . "`n"		; Append cell data with newline

		}
        ; Write the column data to a text file
        FileAppend columnData, xlPathArray[col]		; Change path as needed

   }
    ; Clean up: close Excel workbook, quit Excel application
    wb.Close()
    xl.Quit()
    xl := ""

	if (notifyGroupID != "") 
	{
		if (logOpenBool = false) InitializeLog("GetWorksheetInfo")
		FileAppend(notifyGroupID, logPath, "`n")
		MsgBox(notifyGroupID)
		notifyGroupID := ""
	}
}

return
; -------------||^ Get worksheet info ^||-------------------------------------------------------------
; ---------------------------------------------------------------------------------------------------------------
;         ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;---------------------------------------------------------------------------------------------------------------
;-------------||__Retrieve just the link__||----------------------------------------------------------

!+L::
{
	groupNum := ""
	c := 0
	While (IsNumber(groupNum) = false &&  c <= 10)
	{
		c++
		If (c >= 3)
		{
			groupNum := InputBox("Enter the group ID using only numbers. Non-numeric"
														" entries will be discarded.")
		} else {
			groupNum := InputBox("Group ID:")
		}
	}
	If (c >= 10 && IsNumber(groupNum) = false)
	{
		MsgBox("There was a problem getting the group ID from the input box. The script will"
						" now abort."
		Exit
	} else {
		

















