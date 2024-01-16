>!Left::    MoveActiveWindowBy(-10,   0)
>!Right::   MoveActiveWindowBy(+10,   0)
>!Up::      MoveActiveWindowBy(  0, -10)
>!Down::    MoveActiveWindowBy(  0, +10)

MoveActiveWindowBy(x, y) {
    WinExist "A"  ; Make the active window the Last Found Window  
    WinGetPos &current_x, &current_y
    WinMove current_x + x, current_y + y
}