
; --------------------=================================================================================================
; INTRODUCTION								===========================================================================
; --------------------=================================================================================================
; 
; The purpose of this script, called "Retriever: CSV Lookup" or just "Retriever" for short, is to create a lookup
; function, similar to Excel's native XLOOKUP function, for CSV files.
;
; This project will be completed in several stages. The final product will be a standalone application that provides 
; customizability and a user-friendly interface. The first stage is to create a script that reads a CSV file and 
; performs the intended lookup function. Included in the first stage is the ability to convert a data table from an
; Excel file into a CSV file, without needing to open Excel or do it manually. The second stage will be to create the
; GUI and the fundamental settings. The third stage will be to modify the script to function as a standalone application
; that can be used by someone with no coding experience. The fourth stage will be to create the advanced settings and
; the ability to customize the GUI. 
;
; This is a learning project, and as such I include explanation for why I chose to do things a certain way (to
; reinforce my learning), and also explanations that will help fellow learners as well. A number of functions used
; by this scripts can be applied for other purposes; to that end, I have written the functions to be generalizable,
; take parameters, return values, and exist in standalone .ahk files. If standalone .ahk files are undesirable, the
; user has the option of converting the individual files into a single file.
;
; Current stage: First. Version: 0.1.0
;
; GitHub: 
;
; --------------------=================================================================================================

; --------------------=================================================================================================
; SCRIPT OVERVIEW							===========================================================================
; --------------------=================================================================================================
;
; --------------- Initialization			---------------------------------------------------------------------------
; The first time Retriever is launched it will prompt the user to set up the working directory. The user must have write
; access to the selected directory. If write access is not available, or the initialization procedure fails at any
; point, Retriever displays an error message and ends the script. Subsequent launches will continue to prompt the user
; to set up the working directory until the initialization procedure is completed. This process involves creating
; subdirectories, moving files from the location where "Retriever.zip" was unpacked to the working directory, and 
; writing to text files. Retriever does not use any functions that modify the registry or modify system settings.
;
; The user does not need to maintain write access to the working directory for Retriever to function. This design
; choice is to allow system administrators the ability to provide their users with this script, but prevent any curious
; minds from having access to modify the script, since AutoHotkey can be used to write to the registry and system
; settings. If you are a system administrator and intend to use the script this way, please review
; "Retriever-admin-info.txt". However, in its current version, I do not recommend using Retriever in this way. Please
; wait until stage three has been completed. The remainder of this overview is written under the assumption that the
; user has write access to the working directory.
;
; After the initialization procedure has been completed, subsequent launches will load the process settings from the
; working directory. The user is provided with the choice of using Retriever as a background process to be called with
; a hotkey, or as an application that runs and terminates at completion. Retriever's basic launch behaviors are:
;	1. (default) Start the process, read "Retriever-settings.txt", perform any actions as directed by the settings, and
; 		idle in the system tray until a hotkey is used. When a hotkey is used, the script connected with the hotkey will
;		run. After the script ends, Retriever resumes idling in the system tray. This is recommended for users who will
;		be using Retriever frequently, and who want to keep the process running in the background.
;	2. Start the process, read "Retriever-settings.txt", perform any actions as directed by the settings, prompt the
;		user for an input, perform the lookup, output the result using the selected output method, and then end the 
;		process.
;
; --------------- Hotkeys					---------------------------------------------------------------------------
; 
; This section describes the functions that can be set to hotkeys. This description only includes basic functionality.
; Options in the settings modify function behavior.
; 	Contents:
; 1. Converting an Excel file to a CSV file
; 2. Performing the lookup function
;
; 1. Converting an Excel file to a CSV file
;		This procedure performs these actions:
;		1. Accesses the Excel file
;		2. Starts a new Excel process
;		3. Opens the Excel file
;		4. Loops through each row and column and writes the data to a file in CSV format
;		5. Closes the Excel file
;		6. Ends the Excel process
;
; 2. Performing the lookup function
;		This procedure performs these actions:
;		1. Access the file containing the data to be searched
;		2. Loops through the lines in the file until the search request is fufilled
;		3. Stores the data in an object variable
;		4. Closes the file
;		5. Outputs the result using the selected output method
; 
;
; creating the  it will prompt the user to input 10 values. The script is designed to be run from the command line, and it takes 10 arguments. To launch the script, the user
; can write the command in the command line, or use the included "Retriever-command.ahk" script. "Retriever-command.ahk"
; is a simple script that prompts the user to enter the required information, and then, depending on the user's choices,
; it will: 1) Run the command; 2) Copy the command to the clipboard; 3) Open the command in Notepad; or 4) Exit the
; script.
; This script is designed to read a spreadsheet and extract the data from each column into a CSV file. The script
; is designed to be run from the command line, and it takes 10 arguments.
;	1. The path to the spreadsheet
;		- This can be a local path or a network path. If the path contains spaces, it must be enclosed in quotes.
;		- If using a network path, the user must have the appropriate permissions to access the file. Currently,
;			there is no support for providing a username and password to access the file.
;		- The path must include the file extension.
;	2. The name of the worksheet
;	3. The path to the log file
;	4. The working directory
;	5. The starting row
;		- Set this to `-1` to direct the script to get the first used row. 
;		- Set this to `-2` to direct the script to skip the first row (e.g. a header row) and start at the second row.
;		- Note that this script's functionality will not be effected if the user applies `-1` and the first row
;			contains a header. Select whichever option best suits your needs.if the first row contains the header, it will not effect the function of the script. Select which option best suits your
;			needs.
;	6. The ending row
;		- Set this to `-1` to direct the script to get the last used row.
;	7. The starting column
;		- Set this to `-1` to direct the script to get the first used column.
;	8. The ending column
;		- Set this to `-1` to direct the script to get the last used column.
;	9. A comma-delimited list of paths to the text files for the column data
;	10. The path to the archive directory
; The script will read the spreadsheet, extract the data from each column, and write the data to a text file. If the
; text file already exists, the script will prompt the user to decide if the script should overwrite the file or move
; it to the archive directory. If the archive directory is not provided, the script will create a new directory in
; the working directory. The script will also check for any group IDs which contain non-numeric characters, and it
; will write that information to the log and send a message to the user. The script will also write the data to the
; log file. If the log file does not exist, the script will prompt the user to create a new one. If the user declines,
; the script will continue without logging. The script will also check if the working directory ends in a backslash,
; and if not, it will add one. The script will also check if the text files already exist and contain data, and if so
; it will prompt the user to decide if the script should overwrite the information or save it. If the user declines,
; the script will continue without writing the data to the text files.
; --------------------=================================================================================================

#SingleInstance force
#Requires AutoHotkey v2.0-a

; --------------------=================================================================================================
; ARGUMENTS			===================================================================================================
; --------------------=================================================================================================

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

; ~~~	Error codes		++++++++++++++++++++++;+
;												;++
; 001 - Unable to initialize log				;++
; 002 - Unable to copy array to file			;++

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
; ==========		INITIALIZATION		====================================
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
; ==========		INITIALIZE LOG		====================================
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
; ==========		MISCELLANEOUS FUNCTIONS		============================
; ==========================================================================

; --------------------------------------------------------------------------------------------------------------||
; --------------------	Update notifyGroupID										 							||
; --------------------------------------------------------------------------------------------------------------||

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
						
; --------------------------------------------------------------------------------------------------------------||
; --------------------	Check if a user-submitted path ends in "\"	 											||
; --------------------------------------------------------------------------------------------------------------||

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

; --------------------------------------------------------------------------------------------------------------||
; --------------------	Copy array to file 																		||
; --------------------------------------------------------------------------------------------------------------||

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
; ==========		PROCEDURES		========================================
; ==========================================================================

; --------------------------------------------------------------------------------------------------------------||
; --------------------	Get worksheet info																		||
; --------------------------------------------------------------------------------------------------------------||

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
															' anything else to write over the current files.'
															, , , "1")
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
    xl.Visible := False							; a new instance of Excel, which is what we want in this
    wb := xl.workbooks.open(xlpath)				; case. For attaching to an existing Excel instance, use 
	ws := wb.worksheets(xlSheet)				; `ComObjActive("Excel.Application")`
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

; --------------------------------------------------------------------------------------------------------------||
; --------------------	Retrieve just the link																	||
; --------------------------------------------------------------------------------------------------------------||


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
		

















