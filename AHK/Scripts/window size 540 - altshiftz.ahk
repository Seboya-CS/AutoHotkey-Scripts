#Requires AutoHotkey v2.0
f3::suspend

!+z:: 
{
    WinGetPos ,, &Width, &Height, "A"
    H := 540
    W := ((H * Width) / Height)
    WinMove(,, W, H, "A",,,)

}

!+D:: 
{
    WinGetPos ,, &Width, &Height, "A"
    H := 600
    W := ((H * Width) / Height)
    WinMove(,, W, H, "A",,,)

}

!+F:: 
{
    WinGetPos ,, &Width, &Height, "A"
    H := 540
    W := 960
    WinMove(,, W, H, "A",,,)

}

!+V:: 
{
    WinGetPos ,, &Width, &Height, "A"
    H := 1080
    W := 960
    WinMove(,, W, H, "A",,,)

}

