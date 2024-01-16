InitializeLog() {
    try
        logFile := FileOpen(logPath, "a")
    catch as err {
        response = InputBox("There was an error accessing the log. Attempt to create a new one?", "Error", "Yes" "No", "No")
    }
    if (response == "Yes") {
        logFile := FileOpen(logPath, "w")
        logFile.Write("Log created on " A_Now)
        logFile.Close()
    }
    else {
        MsgBox("Unable to create log file. Exiting.")
        ExitApp
    }
}