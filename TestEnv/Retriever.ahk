#Requires AutoHotkey >=2.0- <2.1
#SingleInstance force

#Include Retriever-settings

SetWorkingDir rDir.workingDir

if (rInit.complete = 0) {
    Retriever-initialization(rDir.workingDir)
}