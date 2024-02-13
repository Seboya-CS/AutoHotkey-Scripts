#Requires AutoHotkey v2.0
#SingleInstance force
#Include Help-constants.ahk

!+1:: ; Alt Shift 1
{
    filePath := "C:\Users\westn\OneDrive\OneDrive\all documents\Github repositories\Seboya\AutoHotkey-Scripts\AHK\Scripts\wip\Test.ahk"
    cmdStr := 'start "" "' A_AhkPath '" "' filePath '"'
    Run filePath
}

!+2::
{
   filePath := "C:\Users\westn\OneDrive\OneDrive\all documents\Github repositories\Seboya\AutoHotkey-Scripts\AHK\Scripts\Writing-helpers\ReloadFunc.ahk"
    cmdStr := 'start "" "' A_AhkPath '" "' filePath '"'
    Run filePath
}