#Requires AutoHotkey >=2.0- <2.1

; This is the settings file for "Retriever.ahk". The settings are loaded into the primary thread as objects. Objects
; contain key-value pairs, where the key is an object property. Individual settings are grouped together conceptually.
;
;   Conventions
;       - Settings are grouped together conceptually as object properties.
;       - Settings object names begin with "r" to indicate they are settings.
;       - Shorthand is used where easily recognizable.

rVer := {
    version: "0.1.0",
    date: "2024-02-08",
    author: "Cebolla: Southwest Automations",
    license: "MIT"
}

rDir := {
    workingDir: A_ScriptDir,        ; A_ScriptDir is the directory containing the script file.
    lib: "Lib",
    readOnly: "",
    readWrite: ""
}


rInit := {
    adminOnly: 0,
    complete: 0,
}


