With this idea, I'm actually going to change my approach to what the <action> was originally going to be. This will be much simpler and effective.

The <action> was going to be to record the call start time, and a couple other miscellaneous tasks. Doing so is no longer necessary because that information is freely available in the log.

A much more robust can be developed by leveraging the call log. I'm going to write a script that performs this general outline:

; When the script, "CallHistory.ahk", is launched for the first time it
	a. Checks for read/write access of the appropriate directories, in addition to their existence. If fail, returns an error and sends a message to the user. If success, proceeds.
	b. initLogContents := FileRead(zuluPath)
2. Prepares the information
	a. Checks if "call_history.log" and "call_information.txt" already exists in the working directory, and if so, asks the user what to do. If not, proceeds.
	b. Parses initLogContents to extract the needed information and stores each item into an array, callsA := Array([])
	c. Sets some variables
		i. zuTotalLines := CountSubstrings(initLogContents, "`n") + 1
		ii. zuTotalSize := FileGetSize(zuluPath)
		iii. zuLen := StrLen(initLogContents)
		iv. initTime := A_Now
		v. zuCombined := "Total lines: " zuTotalLines ".`r`nTotal characters: " zuLen ".`r`nTotal size: " zuTotalSize " bytes.`r`nInitialization time: " FormatTime(initTime, "yyyy-MM-dd hh:mm:ss) "."
		vi. zuTail := SubStr(initLogContents, (zuLen - 600))
3. Write the information to file.
	a. try {
		oCallInfo := FileOpen("call_info.txt", "rw")
		Loop callsA.Length {
			try {
				oCallInfo.Write(callsA[A_Index] "`r`n")
			} catch Error as err {
				oCallInfo.close
				addtlInfo := 'The script was attempting to write the contents of callsA[] to file "call_info.txt" in ' A_WorkingDir '". A list of script variables will be displayed after this message is cleared from the screen by hitting "OK."'
				ErrorHandler(errorcode, err, addtlInfo)
				initErrorBool := true	; If the ErrorHandler doesn't end the script, modify script behavior accordingly.
				ListVars
				Pause
			}
		}
	} catch Error as err {
		addtlInfo := 'File name the script attempted to write: "call_info.txt".'
		ErrorHandler(errorcode, err, addtlInfo "`r`n" zuCombined)
	}
	oCallInfo.Close
	
	c. try {
		oChLog.Open("call_history.log", "rw")
		try {
			oChLog.Write(zuCombined "`r`n`r`n" zuTail)
	} catch Error as err {
		addtlInfo: 'File name the script attempted to write: "call_history.log".'
		ErrorHandler(errorcode, err, addtlInfo "`r`n" zuCombined
	d. oChLog.Close
	e 
		
	d. 
	oChLog := FileOpen("Call_history.log", "rw")
	c. oChLog.write(initLogContents)
3. Parses 
	
	reads the call log, "zulu.log", copies zulu.log to a text file in the working directory.
2. CallHistory.ahk begins writing to the script's log, "Call_history.log". 
3. The functions within CallHistory.ahk will parse zulu.log into the needed components, primarily call information, and save it to "Call_info.txt" in the working directory. Additional information may be gathered, such as:
	a. 
	b. zuTotalLines := [number of lines within "zulu.log"]. ; This number will hover around the same value over time, due to the max log size. This will be used to gather statistical information.
	c. zuCurrentLine := 0 ; The initialization procedure sets it to 0 because the entire log is being parsed. Subsequent procedures will set zuCurrentLine := [The line number within zulu.log that divides the log information that was accessed by the previous proedure, and the log information that is being accesed by the active procedure].
	d. CallHistory.ahk closes "zulu.log".
4. call.ahk then sets some variables and writes to "Call_history.log":
	a. chLogPos := [current cursor position, representing the end of the Call_history.log in its current state]
	b. chLineNum := [number of lines within "Call_history.log" in its current state]
4. After completing the initialization, it sets a timer for 15 minutes and idles in the system tray.
5. Each 15 minutes, it repeats the following:
	a. Reads zulu.log.
	b. Searches within zulu.log for the last five lines of "Call_history.log" (which were previously the last five lines of zulu.log) to identify the previous position.
		i. If the search fails, the script will remove one line from the search string at a time and repeat the search until either the search succeeds or the search string is empty. If the search succeeds, it proceeds with the script. if the search fails, it sets a boolean "searchFailBool" := true.
	c. If searchFailBool = true, then CallHistory.ahk will store the entire zulu.log to string variable. Else, it only stores the new portion.
	d. Counts the lines and parses the new log information.
	e. Writes the needed informaiton to callahk.log
	
	
	
errorStr := 'The script encountered an error when writing to the working directory. The script will abort. Listed below are the available details.`r`nWorking Directory: "' A_WorkingDir '"`r`nFile name: "call_info.txt".`r`nWriting failed when attempting to write to line ' A_Index '.`r`nError details: ' err.What '; ' err.Message '; ' err.File '; ' err.Line '; ' err.Stack '.'
MsgBox(errorStr)
ExitApp