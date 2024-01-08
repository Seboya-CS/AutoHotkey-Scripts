# AutoHotkey-Scripts

You can download AutoHotkey.exe here: https://www.autohotkey.com/
But to run it as a portable application, you should instead download the .zip here: https://github.com/AutoHotkey/AutoHotkey/releases
Extract the contents anywhere. Inside the .zip is a file called "WindowSpy". You can use this to set the default app to open .ahk files.
Right-click WindowSpy > open with > browse for files > select the autohotkey.exe that was extracted with the .zip

The scripting language is documented here: https://www.autohotkey.com/docs/v2/

Since the program has been around for a long time, many of the functions that one would want to create have already been created. Be aware,
at some point AutoHotkey updated their scripting language, which is when v2 was introduced. V2 is backwards-compatible
with V1 scripts but only if you enable that in the settings, which I don't believe the portable version is capable of.
I think there's a command that one can include in a script to force it to read as V1 but I'll have to look that up.
If you use someone else's script and it's throwing errors, this is the likely cause and the syntax just needs updated.

The portable version does not have UI access.

Write your own scripts in any text editor and save as .ahk.
To use the script, you can double-click, set it to a hotkey, 
schedule it to run with the task scheduler, etc.

While you can write scripts that activate once then close when completed, that is not the usual use case for Autohotkey.
Autohotkey scripts are generally written with a `return` statement at the end, which and with a hotkey identified at the beginning.
This way, the script idles in the background indefinitely until the process is stopped. Very useful for repetitive taasks.

