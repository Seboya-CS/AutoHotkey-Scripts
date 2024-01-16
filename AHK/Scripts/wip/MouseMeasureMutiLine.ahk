

; Nick retrieved from here https://www.computoredge.com/AutoHotkey/Downloads/MouseMeasureMultiLine.ahk

/*
September 20, 2020 The Delete key now removes the last saved line segment. Ctrl+Delete 
clears the graphics for a new session.

September 10, 2020 This multiline version of the script uses the left mouse button 
as a Hotkey to break the distance measurement into continuous legs. Each click starts
a new leg until pressing the Shift key. The script uses the array MyArray() to track
the individual line segments. After pressing the Shift key, the numbers 1 through
9 turn into Hotkeys for inserting the respective leg distance into any document.

The MouseMeasure.ahk script uses the mouse to calculate a calibrated
distance between two points on the computer monitor.

August 19, 2020

Initiating any action now only requires pressing Ctrl+LButton (Ctrl+Click).
No need to hold down the left-mouse button.The red line continues to follow 
the cursor until until you take one of the following actions:

To calibrate the app range:

	1. Set mouse cursor at start point — CTRL+LButton and release.
	2. Move mouse cursor to end of a known scale.
	3. Press the Alt key.
	4. Enter length of scale and units (i.e. 10 miles), then Submit.

Manual Calibration: CTRL+ALT+Z

To Measure Distance:

	1. Set mouse cursor at start point — CTRL+LButton and release.
	2. Draw line over target distance.
	3. Press the Shift key.
	4. Distance displayed and saved to Clipboard.

Click left-mouse button to add another leg.

Use Hotkeys 1 through 9 to insert leg distance into document. (Only first 9 legs.)

Use cursor keys to move mouse cursor single pixel increments.

To remove the last saved line segment during a session, press the Delete key.

To clear all measurement lines and ToolTips, press Ctrl+Delete.

Ctrl+Escape to Exit App.

CTRL+ALT+F12 for this Help Message.

*/

; core code taken from colt:
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=78930&hilit=ruler
; GDI Plus line drawing graphics functions taken from Hellbend:
; https://www.autohotkey.com/boards/viewtopic.php?p=258228#p258228

#SingleInstance, Force
SetBatchLines,-1
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

; SysGet, VirtualWidth, 78
; SysGet, VirtualHeight, 79

global MyGui := {W: A_ScreenWidth ,H: A_ScreenHeight }
global GdipOBJ:={X: 0 ,Y: 0 ,W: A_ScreenWidth, H: A_ScreenHeight } ; W: MyGui.W ,H: MyGui.H }
global active_Draw:=0

Pixels := 96
NumUnits := 1
Units := "Inches"

Gui, Calibrate:Add, Text, , Use Control+LeftMouseClick, Hold, and Drag`rfor Auto-Calibrate
Gui, Calibrate:Add, Edit, vPixels w75 Section, %Pixels%
Gui, Calibrate:Add, Text, ys , Pixel Range
Gui, Calibrate:Add, Edit, vNumUnits w75 xm section, 1
Gui, Calibrate:Add, Text, ys , Calibration range
Gui, Calibrate:Add, Edit, VUnits w75 xm section, Inches
Gui, Calibrate:Add, Text, ys , Calibration Units
Gui, Calibrate:Add, Button, gCalibrate ys ,Submit


Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs

Gui, 1:Show, Maximize ; % "w" MyGui.W " h" MyGui.H
GdipOBJ := Layered_Window_SetUp(4,GdipOBJ.X,GdipOBJ.Y,GdipOBJ.W,GdipOBJ.H,2,"-Caption -DPIScale +Parent1")
; UpdateLayeredWindow(GdipOBJ.hwnd, GdipOBJ.hdc, GdipOBJ.X, GdipOBJ.Y, GdipOBJ.W, GdipOBJ.H)
MyPen:=New_Pen("FF0000",,5)


scaleFactor := NumUnits/Pixels ; .568 ;your calibration factor to convert pixels to units

; Remove semi-colon before Return to prevent Help message display at startup.

HelpMe:

MsgBox, 0, MouseMeasure Help,
(
To calibrate the app range:

	1. Set mouse cursor at start point — CTRL+LButton and release.
	2. Move mouse cursor to end of a known scale.
	3. Press the Alt key.
	4. Enter length of scale and units (i.e. 10 miles), then Submit.

Manual Calibration: CTRL+ALT+Z

To Measure Distance:

	1. Set mouse cursor at start point — CTRL+LButton and release.
	2. Draw line over target distance.
	3. Press the Shift key.
	4. Distance displayed and saved to Clipboard.

Use cursor keys to move mouse cursor single pixel increments.

Click left-mouse button to add another leg.

Use Hotkeys 1 through 9 to insert leg distance into document. (Only first 9 legs.)

To remove the last saved line segment during a session, press the Delete key.

To clear all measurement lines and ToolTips, press Ctrl+Delete.

Ctrl+Escape to Exit App.

CTRL+ALT+F12 for this Help Message.
)

Return

^!F12::GoSub, HelpMe


^!Z::GoSub, ManSet

updatePos:
	mouseGetPos,x,y
	dx := x-sx
	dy := sy-y
	dist := round(  ((dx)**2 + (dy)**2) **.5  ,3)
    legtot := totdist + dist
	distCalibrated := round(dist * scaleFactor,3)
	legtotCalibrated := round(legtot * scaleFactor,3)
	tooltip [%dx%:%dy%]`n%dist% px`n%distCalibrated% %units%`n%legtotCalibrated% %units%
return

Calibrate:
 Gui, Submit
 scaleFactor := NumUnits/Pixels
Return

GuiClose:
*^ESC::
	Layered_Window_ShutDown(GdipOBJ)
	ExitApp
Return

ManSet:
	Gui, Calibrate:Show, , Scale Calibration
Return

DrawStuff:
	Gdip_GraphicsClear(GdipOBJ.G)
	MouseGetPos,ex,ey
	Gdip_DrawLine(GdipOBJ.G, myPen, sx, sy, ex, ey)
	loop, % Array_count	{
		Gdip_DrawLine(GdipOBJ.G, myPen, MyArray[A_Index].sx, MyArray[A_Index].sy, MyArray[A_Index].ex, MyArray[A_Index].ey)  ;Your G replaces GdipOBJ.G
	}

	UpdateLayeredWindow(GdipOBJ.hwnd, GdipOBJ.hdc)
	if(GETKEYSTATE("Shift")){
		SetTimer updatePos, off
		SetTimer,DrawStuff,off
		Array_count++
;		totdist := totdist + dist
		MyArray[Array_count] := {sx:sx,sy:sy,ex:ex,ey:ey,pixellength:dist,length:distCalibrated,total:legtotCalibrated}
		active_Draw:=0
		ToolTip, %distCalibrated% %units%, %ex%, %ey%, % Array_count + 1
		tooltip Distance measured is : %legtotCalibrated% %units%  
		clipboard := legtotCalibrated
        MsgLine := ""
		loop, % Array_count	{
			MsgLine := MsgLine . "Leg " A_Index ": " MyArray[A_Index].length " Total: " MyArray[A_Index].total " " units "`n"
			If A_Index < 10
				 Hotkey, % "$" A_Index , DistanceSend, On
		}
		MsgBox, 4096, Multi-Leg Mouse Measure, % MsgLine
;		Gdip_DeletePen(myPen)
	}
	if(GETKEYSTATE("Alt")){
		active_Draw:=0
		setTimer updatePos, off
		SetTimer,DrawStuff,off
		ToolTip
		Gdip_GraphicsClear(GdipOBJ.G)
		UpdateLayeredWindow(GdipOBJ.hwnd, GdipOBJ.hdc)
		clipboard := distCalibrated
		GuiControl, Calibrate:, Pixels, %dist%
	    Gui, Calibrate:Show, , Scale Calibration
	}


Return

#If (active_Draw=0)
^LButton::
	mouse_click := 1
	active_Draw := 1
		loop, % Array_count	{
            If A_Index < 10
		 		Hotkey, % A_Index , , Off UseErrorLevel
			ToolTip, , , , % A_index + 1
		}
	Global MyArray := Array()
	Array_count := 0
    totdist := 0
	MouseGetPos,sx,sy ; start position for measurement
	SetTimer, updatePos,50
	SetTimer,DrawStuff,50
Return
Return

#If (active_Draw=1)
LButton::
	Array_count++
	totdist := totdist + dist
	MyArray[Array_count] := {sx:sx,sy:sy,ex:ex,ey:ey,pixellength:dist,length:distCalibrated,total:legtotCalibrated}
	MouseGetPos,sx,sy
	ToolTip, %distCalibrated% %units%, %ex%, %ey%, % Array_count + 1
; Uncomment and use the following code for separate line segments
/*
	if mouse_click = 1  
	{
		mouse_click := 0
		Array_count++
		totdist := totdist + dist
		MyArray[Array_count] := {sx:sx,sy:sy,ex:ex,ey:ey,pixellength:dist,length:distCalibrated,total:legtotCalibrated}
		ToolTip, %distCalibrated% %units%, %ex%, %ey%, % Array_count + 1
		SetTimer,DrawStuff,off
	}
	else
	{																															
		mouse_click := 1
		MouseGetPos,sx,sy
		SetTimer,DrawStuff,50
	}
*/
Return

Delete::
	ToolTip, , , , % Array_count + 1
	totdist := totdist - MyArray[Array_count].pixellength
	Array_count--
	sx := MyArray[Array_count].ex
	sy := MyArray[Array_count].ey
Return


#If

^Delete::
		active_Draw:=0
		setTimer updatePos, off
		SetTimer,DrawStuff,off
		ToolTip
		loop, % Array_count	{
            If A_Index < 10
		 		Hotkey, % A_Index , , Off UseErrorLevel
			ToolTip, , , , % A_index + 1
		}
		Array_count := 0
		Gdip_GraphicsClear(GdipOBJ.G)
		UpdateLayeredWindow(GdipOBJ.hwnd, GdipOBJ.hdc)
Return


~Up::MouseMove, 0, -1, 0, R  ; UpArrow hotkey => Move cursor upward
~Down::MouseMove, 0, 1, 0, R  ; DownArrow => Move cursor downward
~Left::MouseMove, -1, 0, 0, R  ; LeftArrow => Move cursor to the left
~Right::MouseMove, 1, 0, 0, R  ; RightArrow => Move cursor to the right

DistanceSend:
	keyvar := substr(A_ThisHotkey,2,1)
	SendInput,  % MyArray[keyvar].Length
Return

; GDIP Functions

;--------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawLine"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2)
}
Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}
Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}
Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}
Layered_Window_ShutDown(This)
	{
		SelectObject(This.hdc,This.obm)
		DeleteObject(This.hbm)
		DeleteDC(This.hdc)
		gdip_deleteGraphics(This.g)
		Gdip_Shutdown(This.Token)
	}
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
   
	return DllCall("UpdateLayeredWindow"
					, Ptr, hwnd
					, Ptr, 0
					, Ptr, ((x = "") && (y = "")) ? 0 : &pt
					, "int64*", w|h<<32
					, Ptr, hdc
					, "int64*", 0
					, "uint", 0
					, "UInt*", Alpha<<16|1<<24
					, "uint", 2)
}
DeleteObject(hObject)
{
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}
Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
    Return pBitmap
}
Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}
New_Brush(colour:="000000",Alpha:="FF")
	{
		;~ static Hellbent_Brush:=[]
		new_colour := "0x" Alpha colour 
		;~ Hellbent_Brush[Hellbent_Brush.Length()+1]:=Gdip_BrushCreateSolid(new_colour)
		return Gdip_BrushCreateSolid(new_colour)
	}
Fill_Box(pGraphics,pBrush,x,y,w,h)	
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		return DllCall("gdiplus\GdipFillRectangle"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h)
	}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}
Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, "float", dx
				, "float", dy
				, "float", dw
				, "float", dh
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}
Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Layered_Window_SetUp(Smoothing,Window_X,Window_Y,Window_W,Window_H,Window_Name:=1,Window_Options:="")
	{
		Layered:={}
		Layered.W:=Window_W
		Layered.H:=Window_H
		Layered.X:=Window_X
		Layered.Y:=Window_Y
		Layered.Name:=Window_Name
		Layered.Options:=Window_Options
		Layered.Token:=Gdip_Startup()
		Create_Layered_GUI(Layered)
		Layered.hwnd:=winExist()
		Layered.hbm := CreateDIBSection(Window_W,Window_H)
		Layered.hdc := CreateCompatibleDC()
		Layered.obm := SelectObject(Layered.hdc,Layered.hbm)
		Layered.G := Gdip_GraphicsFromHDC(Layered.hdc)
		Gdip_SetSmoothingMode(Layered.G,Smoothing)
		return Layered
	}
Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}
New_Pen(colour:="000000",Alpha:="FF",Width:= 5)
	{
		;~ static Hellbent_Pen:=[]
		new_colour := "0x" Alpha colour 
		;~ Hellbent_Pen[Hellbent_Pen.Length()+1]:=Gdip_CreatePen(New_Colour,Width)
		return Gdip_CreatePen(New_Colour,Width)
	}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
SelectObject(hdc, hgdiobj)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}
DeleteDC(hdc)
{
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
Gdip_Shutdown(pToken)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}
Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
	return pBrushClone
}
Gdip_FontFamilyCreate(Font)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, Ptr, &wFont, "int", nSize)
	}
	
	DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, Ptr, A_IsUnicode ? &Font : &wFont
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "UInt*", hFamily)
	
	return hFamily
}
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
   return hFont
}
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
   return hFormat
}
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
}
Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)   
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	DllCall("gdiplus\GdipMeasureString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, &RC
					, "uint*", Chars
					, "uint*", Lines)
	
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	return DllCall("gdiplus\GdipDrawString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, pBrush)
}
Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}
Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}
Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}
Gdip_SetImageAttributesColorMatrix(Matrix)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}
Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
   return Width
}
Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
   return Height
}
Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}
Gdip_Startup()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}
Create_Layered_GUI(Layered)
	{
		Gui,% Layered.Name ": +E0x80000 +LastFound " Layered.Options 
		Gui,% Layered.Name ":Show",% "x" Layered.X " y" Layered.Y " w" Layered.W " h" Layered.H " NA"
	}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	
	NumPut(w, bi, 4, "uint")
	, NumPut(h, bi, 8, "uint")
	, NumPut(40, bi, 0, "uint")
	, NumPut(1, bi, 12, "ushort")
	, NumPut(0, bi, 16, "uInt")
	, NumPut(bpp, bi, 14, "ushort")
	
	hbm := DllCall("CreateDIBSection"
					, Ptr, hdc2
					, Ptr, &bi
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "uint*", ppvBits
					, Ptr, 0
					, "uint", 0, Ptr)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}
CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
    return pGraphics
}
Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
   return pPen
}
Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt*", Region)
	return Region
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillRectangle"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h)
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}
Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}
Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawEllipse", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}
GetDC(hwnd=0)
{
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}
ReleaseDC(hdc, hwnd=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}
Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	return Region
}

