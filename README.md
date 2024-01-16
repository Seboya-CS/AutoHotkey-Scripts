# AutoHotkey-Scripts

    Introduction

AutoHotkey is a scriping tool and language that was first introduced in 2003. The developers gave their product away for free, and the maintainers have since stayed true to that vision. AutoHotkey (AHK) usage has since lowed as other more modern tools have taken its place, but as a simple scripting program that can interact with the Windows OS, AHK still finds a home in many users' toolkits.

    Installation

You can download AutoHotkey.exe here: https://www.autohotkey.com/
But to run it as a portable application, you should instead download the .zip here: https://github.com/AutoHotkey/AutoHotkey/releases
Extract the contents anywhere. Inside the .zip is a file called "WindowSpy". Activating WidowSpy will show you detailed information about the active window (intended to help the user write scripts which interact with open windows). You can also use this to set the default app to open .ahk files. Right-click WindowSpy > open with > browse for files > select the autohotkey.exe that was extracted with the .zip.

    Usage

The scripting language is documented here: https://www.autohotkey.com/docs/v2/

Scripts are written in plain text files and saved with the .ahk extension.

Since the program has been around for a long time, many of the functions that one would want to create have already been created. Be aware, when AHK released the V2 update, the syntax changed dramatically causing there to be a significant split between V1 and V2 scripts. If you attempt to use someone's script and it is throwing errors, this is a likely cause.

To use a script, you can double-click its icon, run it in the command line with arguments and parameters (see https://www.autohotkey.com/docs/v2/Scripts.htm#cmd), schedule it to run with the task scheduler, use one AHK script to run the other, etc. When a script is active, it's icon will be visible in the system tray.

While AHK can be used for automating procedures that perform a routine from start to finish then terminte after finishing, that is not the usual use case for Autohotkey. Where AutoHotkey shines is as a tool to set custom keyboard shortcuts to perfor automation tasks that one would benefit from throughout the day, or in specific circumstances such as presentations, data entry, or script writing.. Even if all one ever uses AutoHotkey for is to bind Powershell scripts to keybinds, that is nonetheless representative of what make AutoHotkey valuable to anyone who works in front of a keyboard. Powershell does not have native custom keybinding support outside of the Powershell active window, and neither do most programs. But with AutoHotkey, almost any procedure can be initiated by a custom keyboard shortcut.

After activating a script, unless that script is designed to run through its procedure then terminate, the script will idle in the system tray until it detects the shortcut. When the shortcut is activated, the script will activate as well.

    Examples

The AutoHotkey .zip comes with many examples of complete scripts to serve as a guide, and the documentation provides many examples as well.