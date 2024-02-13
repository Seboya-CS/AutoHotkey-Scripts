
#Requires Autohotkey v2
;AutoGUI 2.5.8 
;Auto-GUI-v2 credit to Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter credit to github.com/mmikeww/AHK-v2-script-converter

initDir := Gui()
initDir.OnEvent("Close", initDirGuiEscape)
initDir.OnEvent("Escape", initDirGuiEscape)
initDir.SetFont("s12 cWhite")
initDir.BackColor := "0x000000"
initDir.SetFont("s12 c0xFFFFFF")
ogcRadiorad1 := initDir.Add("Radio", "vrad1  x72 y64 w205 h23", "The script's local directory")
ogcRadiorad1.Opt("Background000000")
ogcRadiorad1.OnEvent("Click", OnEventHandler)
initDir.OnEvent('Close', (*) => ExitApp())
initDir.Title := "Initialization - Directory"
initDir.Show("w670 h475")
rad1(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ogcRadiorad1 => " ogcRadiorad1.Value "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
