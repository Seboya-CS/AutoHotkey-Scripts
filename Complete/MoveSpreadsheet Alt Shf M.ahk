
filePath := ""
notesDir := ""
day := FormatTime(A_Now, "ddd")
nday := FormatTime(A_Now, "d")
nmonth := FormatTime(A_Now, "MM")
nyear := FormatTime(A_Now, "yyyy")

Switch day 0 {
    Case "tue", "wed", "thu", "fri":
        nday := Number(nday) - 1
    Case "sat":
        nday := Number(nday) - 2
    Case "sun":
        nday := Number(nday) - 3
    Case "mon":
        nday := Number(nday) - 4
}

if (nday <= 9) {
    nday := "0" nday
} else {
    nday := nday
}

thedate := nyear "-" nmonth "-" nday

d := InputBox("New file name", , , thedate)
c := 1
newPath := notesDir "\" d " c" c ".xlsm"
bool := false
while (bool = false && c <= 4) {
    if (FileExist(newPath)) {
        c++
        newPath := notesDir "\" d " c" c ".xlsm"
    } else {
        bool := true
    }
}
try {
    FileCopy(filePath, newpath, 0)
} catch Error as err {
    MsgBox("Error: " err.Message)
}
