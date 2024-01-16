#SingleInstance force

!1::
{ 
	DoubleOne := A_PriorHotkey = "!1" AND A_TimeSincePriorHotkey < 400
	TwoOne := A_PriorHotkey = "!2" AND A_TimeSincePriorHotkey < 400
	If DoubleOne
	{
		string := A_Clipboard
		sleep 100
		A_Clipboard := "This is the follow-up to my voicemail. I’m writing from SAGE’s technical support team. We received a notification that there were some technical difficulties, so I'm reaching out to offer some assistance. If you would like to schedule an appointment to work on this, please reply to this email with what time works best for you. I’m here Monday – Thursday 8:30AM – 7:30PM.`r`n`r`nThank you,`r`n`r`n"
		sleep 50
		send "^v"
		sleep 100
		A_Clipboard := string
	}
	If TwoOne
	{
		string := A_Clipboard
		sleep 100
		A_Clipboard := "Writer received a request to contact the client for technical support. Writer called and spoke with the client. "
		sleep 50
		send "^v"
		sleep 100
		A_Clipboard := string
	}
}
return

!2::
{
	OneTwo := A_PriorHotkey = "!1" AND A_TimeSincePriorHotkey < 400
	If OneTwo
	{
		string := A_Clipboard
		sleep 100
		A_Clipboard := "Writer received a request to contact the client for technical support. Writer called, left a voicemail, and sent an email."
		sleep 50
		send "^v"
		sleep 100
		A_Clipboard := string
	}
}
