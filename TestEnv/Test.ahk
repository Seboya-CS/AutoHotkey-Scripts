#SingleInstance force
#Requires AutoHotkey v2.0-a

; 
xlPath := A_Args[1]
xlSheet := A_Args[2]
logPath := A_Args[3] 
workingDir := CheckForSlash(A_Args[4])
startRow := A_Args[5]
endRow := A_Args[6]	; Set this to `-1` to direct the script to get the last used row.
startCol := A_Args[7]
endCol := A_Args[8]		; Set this to `-1` to direct the script to get the last used column.
xlTextFiles := A_Args[9]	; Comma-delimited list of paths for column data files.
archiveDirectory := A_Args[10]	; Path to save old spreadsheet data or logs, if needed.
															; Set this to "" to use the default archive directory.

; ~~~		Error codes		++++++++++++++++++++++;+
; 																								;++
; 001 - Unable to initialize log											;++
; 002 - Unable to copy array to file								;++

; ~~~+++++++++++++++++++++++++++++++++++;+

; @@@		To dos		@@@+++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;	Complete the create archive / move files section, move it out of the current function its
;		in, and modify it to be a standalone function that takes parameters and returns a boolean
;		Use global variables to share information about the script between functions.
;	Review the create archive / move files function and review InitializeLog(), and make a
;		decision if those should be broken down into their parts as a series of smaller functions.
;	Add in support for setting endRow and endCol to -1 to default to last used row/column
;	Create the user settings 
;	Standardize style
;	Switch absolute paths to relative paths in workingDir
;
; @@@@@@@@@@@@++++++++++++++++++++++++++++++++++++++++++++++++++++++


; ==========================================================================
; ==========		INITIALIZATION		===============================================
; ==========================================================================

; Check if the arguments are provided
if A_Args.capacity < 10 {
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

; ==========================================================================
; ==========		INITIALIZE LOG		===============================================
; ==========================================================================
InitializeLog(callingProcedure := "") {    	; The `callingProcedure` variable is to know which
    global logOpenBool									; procedure called the function, for debugging.
	try {																	
        logFile := FileOpen(logPath, "a")
        if !logFile {
            throw "Unable to open file"
        }
    } catch as err {
        result := InputBox('There was an error accessing the log. Attempt to create a new one?'
										' Submit "1" for yes. Submit anything else for no.', "Error 001", "1")
        if result = "1" {
            try {
                logFile := FileOpen(logPath, "rw")
                if !logFile {
                    throw "Unable to create file"
                }
            } catch as err {
                MsgBox('Unable to create log file. Please check the file path and directory'
								' permissions. Exiting the script.')
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
        logFile.Write("Calling procedure: " callingProcedure ". Process initialization: " A_Now 
								"`r`n")
    }
    logOpenBool := true
    return 1
}

; ==========================================================================
; ==========		MISCELLANEOUS FUNCTIONS		=================================
; ==========================================================================

; --------------------------------------------------------------------------------------------------------------	||
; --------------------	Update notifyGroupID										 							||
; --------------------------------------------------------------------------------------------------------------	||

UpdateNotifyMsg(uChar, uRow, uUnchangedID)
{
	global notifyGroupID
	If (notifyGroupID= "") {
		notifyGroupID :=  uChar . " was removed from row " . row . " . Group ID: " . uUnchangedID
	} else {
		notifyGroupID := (
										notifyGroupID . "`n" . uChar . " was removed from row " . uRow . ". Group"
										" ID: " . uUnchangedID
		)
	}
	return
}
						
; --------------------------------------------------------------------------------------------------------------	||
; --------------------	Check if a user-submitted path ends in "\"	 							||
; --------------------------------------------------------------------------------------------------------------	||

CheckForSlash(path)
{
	strL := StrLen(path)
	lastChar := SubStr(path, strL, 1)
	if (lastChar = "\") {
		return(path)
	} else {
		return(path . "\")
	}
}



; ==========================================================================
; ==========		FILE READING FUNCTIONS		=====================================
; ==========================================================================

; --------------------------------------------------------------------------------------------------------------	||
; --------------------	Copy array to file 																			||
; --------------------------------------------------------------------------------------------------------------	||

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
			logFile.Write("Calling procedure: " callingProcedure ". Copying array to file: " A_Now 
									"`r`n" "Array dimensions: Rows: " nRow ". Columns: " nCol ". `r`n")
            for nRow, nCol, value in array {
                file.Write("[" nRow "] [" nCol "] : " value  "`r`n")
            }
        }
        Catch as err {
            MsgBox ("Error 002. There was an error copying the array to file."
							" Logging is disbaled until restart.")
            noLogBool := true
        }
    } 
    return
}


; ==========================================================================
; ==========		PROCEDURES		===============================================
; ==========================================================================

; --------------------------------------------------------------------------------------------------------------	||
; --------------------	Get worksheet info																		||
; --------------------------------------------------------------------------------------------------------------	||

!+s::
{ 
	global notifyGroupID	; Declare the global variable within this function
	fileExistsBool := false
	writeOverBool := false
	fileLen := 0
	num := 0
	; The procedure checks if the files already exist and contain data, and if so requests the 
	; user to decide if the procedure should overwrite the information or save it. This will
	; eventually be modified to be a setting which the user can set and modify at will,
	; but for now it will prompt for an input.
	While fileExistsBool = false && num <= 11 {
		num := A_Index
		try {
			fileText := FileRead(xlPathArray[num])
			fileLen := StrLen(fileText)
		} catch Error as err {
		}												; We don't need to take any action if there's an error.
		If (fileLen >= 1) {
			fileExistsBool := true
		}
	}
	
	If (fileExistsBool) {
		response := InputBox('Submit "1" to write over the current files. Submit "2" to move'
			' the current files to the archive directory. Submit "0" to cancel and end the script.', , , "2")
		
		If (response = "0") {
			ExitApp
		} else if (response = "2") {
			if (archiveDirectory = "") {
				newDirName := "Archive-files-" . A_Now
				newDirPath := workingDir . "Archive/" . newDirName
				try {
					DirCreate newDirPath
				} catch Error as err {
					response := InputBox('There was an error creating the archive directory.'
															' Submit "0" to cancel and end the script. Submit'
															' anything else to write over the current files.', , , "1")
					If (response = "0") {
						ExitApp
					} else {
						writeOverBool := true
					}
				} else {
					archiveDirectory := newDirPath
				}
			} else {
				Loop 11 {
					try {
						FileMove(xlPathArray("A_Index"), newDirPath)
					}
				}
			}
		}
	}
	
  ; Initialize Excel COM object (or connect to an existing one)
    xl := ComObject("Excel.Application") 		; Note: `ComObject("Excel.Application")` is used to initialize 
    xl.Visible := False											; a new instance of Excel, which is what we want in this
    wb := xl.workbooks.open(xlpath)				; case. For attaching to an existing Excel instance, use 
	ws := wb.worksheets(xlSheet)					; `ComObjActive("Excel.Application")`
    ws.activate
	
    ; Loop through each column
    Loop nCol
    {
        col := A_Index			; `A_Index` = the current loop as an integer. Starts from 1.
        columnData := ""		; Reset columnData
        Loop nRow		; Loop through every row in col
        {
							
            row := A_Index
            cellValue := ws.Cells(row + startRow - 1, col + startCol - 1).Value	
			
			; Occasionally, the group ID contained within the spreadsheet will have an erroneous
			; character at the beginning or end. These next lines will identify it, remove it, and
			; update notifyGroupID with the information for reporting.
			firstChar := SubStr(cellValue, 1, 1)
			strL := StrLen(cellValue)
			lastChar := SubStr(cellValue, strL, 1)
			if (IsNumber(firstChar) = false) {
				tempStr := SubStr(cellValue, 2, strL - 1)
				strL := StrLen(tempStr)
				updateGroupID(firstChar, row, cellValue)
			} else {
				tempStr := cellValue
			}
			if (IsNumber(lastChar) = false) {
				finalStr := SubStr(tempStr, 1, strL - 1)
				updateNotifyMsg(lastChar, row, cellValue)
			} else {
				finalStr := tempStr
			}
			
			; The procedure stores the entire column data into a string, and then it writes
			; the string to the file. There are many different ways this can be done, each with pros
			; and cons. For the purpose of this script, I decided to delimit each data entry with a new
			; line, and include the row number at the beginning of the line. Storing the column data
			; into a text file is beneficial because launching a new instance of Excel, or even keeping
			; an instance running in the background, uses much more memory. Opening, parsing, 
			; and closing a text file occurs quickly, and the system usage is low. A standard CSV
			; format is another alternative. I decided against a CSV because
			
			If (col = 1)  {
				columnData := columnData . row . ":" . finalStr . "`n"
			} else {
				columnData := columnData . finalStr . "`n"	
			}
		}
        ; Each column is written to an individual text file. If the file exists, it is overwritten.
		; The paths to the files are contained in xlPathArray. The column number is the index
		; to get the path in the array.
        columnFile := FileOpen(xlPathArray[col], "w")
		columnFile.Write(columnData)
		columnFile.Close

   }
    ; Clean up: close Excel workbook, quit Excel application
    wb.Close()
    xl.Quit()
    xl := ""

	; If there were any group IDs on the spreadsheet which contained non-numeric characters,
	; write that information to log and send a message to the user.
	If (notifyGroupID != "") {
		if (logOpenBool = false) InitializeLog("GetWorksheetInfo")
		logFile.Write(notifyGroupID . "`n")
		MsgBox(notifyGroupID)
		notifyGroupID := ""
	}
}

return

; --------------------------------------------------------------------------------------------------------------	||
; --------------------	Retrieve just the link																		||
; --------------------------------------------------------------------------------------------------------------	||


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
		

















