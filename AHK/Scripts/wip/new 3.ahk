#SingleInstance force

SetWorkingDir "C:\Users\westn\OneDrive - SAGE COUNSELING INC\8. AHK\s\mine"
ahkPath := '"' "C:\Users\westn\OneDrive - SAGE COUNSELING INC\8. AHK\AutoHotkey64.exe" '"'
!v::
{
	fileList := Array()
	pathList := Array()
	Loop Files, "*.ahk"
	{
		fileList.push(A_LoopFileName)
		pathList.push(A_LoopFileFullPath)
	}
	msgbox(fileList[1])
	msgbox(fileList[2])
	msgbox(pathList[1])
	msgbox(pathList[2])
	
	Run ahkPath ' "' pathList[1] '"'
} 