#SingleInstance force

SetWorkingDir "C:\Users\westn\OneDrive - SAGE COUNSELING INC\8. AHK\s\Complete"
ahkPath := '"' "C:\Users\westn\OneDrive - SAGE COUNSELING INC\8. AHK\AutoHotkey64.exe" '"'
fileList := Array()
pathList := Array()
fileListAll := Array()

!g::
{
	Loop Files, "*.ahk"
	{
		fileList.push(A_LoopFileName)
		pathList.push(A_LoopFileFullPath)
	}
	n := fileList.Length +  1
	fileListAll := fileList
	fileListAll.push("All")
	
	scriptsG := Gui("-Caption  -MaximizeBox +Resize +MinSize400x100 +MaxSize300x300", "Scripts")
		
	listOfScripts := scriptsG.Add("ListBox", "+Choose6 +8 +W200 x0 y0 vAHKScripts" "+R" n, fileListAll)
	submitButton := scriptsG.Add("Button", "+W70 +H50 x220 y10", "OK")
	submitButton.OnEvent("Click", SubmitList)
	scriptsG.Show

	SubmitList(*)
	{
		For Index, Field in listOfScripts.Text
		{
			If Field = "All"
			{
				For String in pathList
				{
					Run ahkPath ' "' string '"'
				}
			}
			Else
			{
				Run ahkPath ' "' pathList[Index]  '"'
			}
		}
		scriptsG.Destroy
	}
}