#Requires AutoHotkey v2.0callsA
#SingleInstance force

#SetWorkingDir A_ScriptDir

const zPath := "C:\Program Files (x86)\Zulu\zulu.log"
const chPath := "call_history.log"
const ciPath := "call_info.txt"

; <Pseudo-code> When the script, "CallHistory.ahk", is launched it will
; Check for the existence of the needed directories, and checks for read/write access where appropriate. 
; If check fails, .ahk sends a message to the user and ends the script. </Psuedo>

; Preparing the information:
; <Pseudo-code> Check if "call_history.log" and "call_information.txt" already exists in the working directory,
; and if so, prompt the user for an input.

; Create the Zulu log object.
oZulu := {
    lastread: 0,    ; The last time the file was read.
    contents: "".  ; The contents of the file.
    oZulu.fullsize := 0,    ; The size of the file.
    oZulu.totallines := 0,  ; The total number of lines in the file.
    oZulu.currentlines := 0,    ; The number of lines read in the last read.
    oZulu.currentchars := 0,    ; The number of characters read in the last read.
    oZulu.tail := "",   ; The last 600 characters of the file.
    oZulu.string := ""  ; A convenient string for passing these object properties as text.
}

ReadLog(true)    ; Read zulu.log and have the information stored into the object

; <Pseudo-code> Parse oZulu.contents to extract the needed information and stores each item into an array,
;       aCalls := Array([]) </Pseudo>

; Write the information to file.
try {
    oCallInfo := FileOpen(ciPath, "rw")
    Loop aCalls.Length {
        try {
            oCallInfo.Write(aCalls[A_Index] "`r`n")
        } catch Error as err {
            oCallInfo.close
            sAddtlInfo := (
                'The script was attempting to write the contents of ``aCalls[' A_Index ']`` to file'
                ' "' ciPath '" in "' A_WorkingDir '".'
            )
            result := ErrorHandler(errorCode, err, (sAddtlInfo "`r`n" oZulu.string))
        }
    	oCallInfo.Close
    }
} catch Error as err {
    sAddtlInfo := 'The script was attempting to open "' ciPath '" in "' A_WorkingDir '".'
    result := ErrorHandler(errorcode, err, (sAddtlInfo "`r`n" oZulu.string))
}

try {
    oChLog.Open(chPath, "rw")
    try {
        oChLog.Write(oZulu.string "`r`n`r`n" zuTail)
    } catch Error as err {
        sAddtlInfo: (
            'The script was attempting to write the contents of ``oZulu.string`` and ``zuTail`` to file'
            ' "' chPath '" in "' A_WorkingDir '".'
        )
        result := ErrorHandler(errorcode, err, (sAddtlInfo "`r`n" oZulu.string))
    }
    oChLog.Close
} catch Error as err {
    sAddtlInfo: 'The script was attempting to open "call_history.log" in "' A_WorkingDir '".'
    result := ErrorHandler(errorcode, err, (sAddtlInfo "`r`n" oZulu.string))
}

; <Pseudo-code> Write to the settings file that initialization has been completed.</Pseudo>

SetTimer CheckLog, 900000

CheckProcedure()
{
    ; <Pseudo-code> Read the zulu.log file and parse the new information.
    ; <Pseudo-code> Write the needed information to call_info.txt.
    ; <Pseudo-code> Write the needed information to call_history.log.
}

ReadLog(first := false)     ; The first time launching the script requires special actioms. Note that no functions used
                            ; by this script make changes to the registry or system files. Write access is needed for
                            ; at
{
    try {
        ; beInit := false
        zLog := FileOpen(oZulu.path, "r")
    } catch Error as err {
        sAddtlInfo := 'The script was attempting to open "zulu.log" in "' A_WorkingDir '".'
        ErrorHandler(errorcode, err, (sAddtlInfo "`r`n" oZulu.string))
    }

    bSearchFail := false
    nStart := 0
    if (!first) {
        nSearch := InStr(oZulu.contents, oZulu.tail, true)
        sMod := oZulu.tail
        if (!nSearch) {
            c := 0
            While (nSearch = 0 && c < 12) {
                c++
                nStrlen := StrLen(oZulu.tail)
                sMod := SubStr(oZulu.tail, 1, (nStrlen - (50 * c)))
                nSearch := InStr(oZulu.contents, sMod, true)
            }
            if (c = 12 && !nSearch) {
                bSearchFail := true
            }
        }
    }

    if (!first && !bSearchFail) {
        nStart := nSearch + StrLen(sMod) + 1
    }
    
    oZulu.fullsize := FileGetSize(oZulu.path)
    text := zLog.Read
    oZulu.contents := SubStr(text, nStart)
    oZulu.lastread := A_Now
    oZulu.totallines := SubstrCount(text, "`n") + 1
    oZulu.currentlines := SubstrCount(oZulu.contents, "`n") + 1
    oZulu.currentchars := StrLen(oZulu.contents)
    oZulu.tail := SubStr(oZulu.contents, -600)
    oZulu.string := (
        'Last read: ' oZulu.lastread "`r`n"
        'Size: ' oZulu.fullsize "`r`n"
        'Lines: ' oZulu.totallines "`r`n"
        'Chars: ' oZulu.currentchars "`r`n"
        'Contents: ' oZulu.contents "`r`n"
        'Tail: ' oZulu.tail
    )
    ZuluLog.Close
    return(zLog)
}


ErrorHandler(errorcode, errObj, sAddtlInfo := "")
{
    bAbort := false
    bYesNoCancel := false
    bInputBox := false
    bMsgBox := false
    bYesNo := false
    bWroteToLog := false
    bWroteToScreen := false
    bListVars := false

    Switch errorcode
    {
        Case 1001:
            sMsg := ErrorMessages(1001)
            if (sMsg) {
                sTemp := 
            bAbort := true
            bMsgBox := true
            sMsg := sMsgComp1 . sAddtlInfo
        Case 1002:
            bAbort := true
            bMsgBox := true
            bListVars := true

            sMsg := sMsgComp2 . sAddtlInfo



    }

}

ErrorMessages(nMsgCode)
{
    sReturn := ""
    Switch errorcode
    {
        Case 1001:
            sMsg := 

    
    sMsgComp1 := (
        'The script encountered an error when writing to the working directory. The script will abort.`r`n'
        ' Listed below are the available details.`r`n'
        ' Error details: ' errObj.What '; ' errObj.Message '; ' errObj.File '; ' errObj.Line '; ' errObj.Stack '.`r`n'
        ' Working Directory: "' A_WorkingDir '"`r`n'
    ) 
    sMsgComp2 := (
        'The script encountered an error when writing to the working directory. The script will abort.`r`n'
        ' Listed below are the available details.`r`n'
        ' Error details: ' errObj.What '; ' errObj.Message '; ' errObj.File '; ' errObj.Line '; ' errObj.Stack '.`r`n'
        ' Working Directory: "' A_WorkingDir '"`r`n'
    ) 

    sMsgComp2 := (
        'The script encountered an error when writing to the working directory. The script will abort.`r`n'
        ' Listed below are the available details.`r`n'
        ' Error details: ' errObj.What '; ' errObj.Message '; ' errObj.File '; ' errObj.Line '; ' errObj.Stack '.`r`n'
        ' Working Directory: "' A_WorkingDir '"`r`n'
    ) 
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

