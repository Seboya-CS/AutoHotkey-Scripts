#Warn All, Off
#SingleInstance force
#No Env

!b::
{
    ; Check if at least one argument is provided
    if A_Args.Length() < 6
        {
            MsgBox("Please provide the required arguments (xlPath, xlSheet, startRow, endRow, startCol, endCol).")"
            ExitApp
        }
        
        ; Get script parameters from arguments
        xlPath := A_Args[1]
        xlSheet := A_Args[2]
        startRow := A_Args[3]
        endRow := A_Args[4]
        startCol := A_Args[5]
        endCol := A_Args[6]
ListVars
Pause
        ; Get the number of columns from the arguments
        numCols := endCol - startCol + 1
        
        ; Create an object to hold your arrays
        arrays := {}
        
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
        
    msgbox(arrays[1][1])
    msgbox(arrays[2][1])    
    msgbox(arrays[3][1])    
    msgbox(arrays[4][1])
    msgbox(arrays[5][1])
    msgbox(arrays[6][1])
    msgbox(arrays[7][1])
    msgbox(arrays[8][1])
}
    