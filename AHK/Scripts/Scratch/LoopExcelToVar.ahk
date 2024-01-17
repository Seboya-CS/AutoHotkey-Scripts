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


; ==============  INITIALIZATION  ===========================================================================
; ===========================================================================================================
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

; ==============  INITIALIZE LOG  ===========================================================================
; ===========================================================================================================
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

; ==============  FUNCTIONS =================================================================================
; ===========================================================================================================

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
;-------------||__Generate array__||-------------------------------------------------------------
class array_n extends array {
	; one-based multidimensional array
	; Usage:
	; new_array := array_n.new(dimensions*)
	; dimensions, an array where item k indicates the size of dimension k.
	; Maps any amount of indices to an index in an "underlying" linear array
	; No bound checking is done on dimension level, out of bounds access on the
    ; "underlying" linear array is detected automatically.
	static base_index := 1 ; indicates one-based, subclasses can override this.
	static __new() => this.prototype.class := this ; to allow subclasses to override base_index 
	__new(dimensions*) {
		; calculate the length of the "underlying" array
		l := 1	
		for length in dimensions
			l *= length
		this.length := l 			; sets the capacity of the linear "underlying" array
		this.dim := dimensions		; store dimension sizes for proper index calculation
	}
	__item[indices*] {
		; Access the underlying linear array:
		get => super[ this.getIndex( indices ) ]				
		set => super[ this.getIndex( indices ) ] := value
	}
	
	getIndex(indices) {
		; Calculates the index in the "underlying" linear array
        linear_index 												; linear_index is the index to access in the underlying linear array. 
        := base_index  												; To begin, pretend that the base index of the underlying array matches 
			:= this.class.base_index 								; this base index.
											
		, dimension_offset := 1										; Start at the first "dimension offset"
		, dim := this.dim 											; look up once
		
		; consider (without any regard to base_index): arr[x1, ..., xn] with bounds [d1, ..., dn]
		; then we access underlying_arr[ xn
		; + x{n-1} * dn
		; + x{n-2} * dn * d{n-1}
		; + ...
		; + x1 * d2 * ... * dn ]
		
		; Note: if n < L := this.dim.length, then we do the same as above but with,
		; arr[xk, ..., xL] with bounds [dk, ..., dL] where k := L - n - 1,
		; in particular with n := 1, k becomes L and arr[x] will access underlying_arr[x]
		; which implies that we can access arr[x] for all base_index <= x  < this.length + base_index
		
		loop n := indices.length
			linear_index += (indices[ n ] - base_index)
				* dimension_offset
			, dimension_offset *= dim[ n-- ]	; dn * d{n-1} * ... * d2 
												; (the last iteration will do dimension_offset *= d1 but it will not be used)

		return linear_index	
			- base_index	; compensate for the choosen base index
			+ 1				; compensate for the "underlying" array being one-based
	}
}
;-------------||^ Generate array ^||-------------------------------------------------------------
;------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------
;-------------||__Get worksheet data__||---------------------------------------------------------
%+s::
(	; Initialize Excel COM object (or connect to an existing one)
        xl := ComObjCreate("Excel.Application") ; or ComObjActive("Excel.Application") to attach
						; to an existing instance
        xl.Visible := false

        ; Open the Excel workbook
        xl.Workbooks.Open(xlPath)


        ; Iterate from 1 to numCols
        For k, value in Range(1, numCols)
        {

            ; Loop for Excel cells
            for cells in xl.Sheets(xlSheet).Range("Cells(" startRow ", " startCol + k - 1 "):Cells(" endRow ", " startCol + k - 1 ")")
                arrays[k].Push(cells.Value)  
        }
        
        ; Function to generate a range of numbers (inclusive)
        Range(start, end) {
            range := []
            Loop, % end - start + 1
                range.Push(start + A_Index - 1)
            return range
        }
        
}
;-------------||^ Initialize Excel ^||-------------------------------------------------------------
;------------------------------------------------------------------------------------------------

; Error codes
; 001 - Unable to initialize log
; 002 - Unable to copy array to file
