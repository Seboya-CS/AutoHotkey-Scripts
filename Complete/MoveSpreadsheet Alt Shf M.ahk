
filePath := ""
notesDir := ""
d := FormatTime(A_Now, "yyyy-MM-dd")
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
