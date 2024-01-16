!+r::  ; Alt + Shift + Z as the hotkey
{
    Send "{F12}"  ; Open Developer Console (adjust based on your browser)
    Sleep 1000  ; Wait for the console to open

    jsCode := "setTimeout(() => { let dropdownItem = document.querySelector('.btn-group.dropup .dropdown-menu li:nth-child(3) a'); if (dropdownItem) { dropdownItem.textContent = '2000'; setTimeout(() => { dropdownItem.click(); }, 250); } else { console.log('Dropdown item not found'); } }, 200);"
    
    ; Copy the JavaScript code to clipboard
    A_Clipboard := jscode
    Sleep 100  ; Wait for the clipboard to be ready

    ; Paste the JavaScript code
    Send "^v"  ; Ctrl + V to paste
    Sleep 100  ; Short delay

    ; Execute the JavaScript code
    Send "{Enter}"
    Sleep 500  ; Wait for the code to execute

    Send "{F12}"  ; Close Developer Console (use the same key used to open it)
}
return