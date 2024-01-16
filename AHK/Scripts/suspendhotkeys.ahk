; Toggle suspension of specific hotkeys with F2
ToggleSuspend := False  ; Initialize the toggle variable

; Define the keybind to toggle suspension
F2::ToggleSuspend := !ToggleSuspend

; If the toggle is off, disable specific hotkeys
#If ToggleSuspends
; This condition will only be true when ToggleSuspend is True (i.e., when F2 is pressed)

; Suspend specific hotkeys
^+F::Suspend
^+G::Suspend
^+V::Suspend
^+B::Suspend
^+Z::Suspend
^+X::Suspend
^LButton::Suspend
!RButton::Suspend
!LButton::Suspend
^+e::Suspend
^+r::Suspend
^+w::Suspend
^+a::Suspend
^+s::Suspend
!1::Suspend
!2::Suspend
!3::Suspend
!4::Suspend
!+d::Suspend
!+z::Suspend

#If
; You can add more hotkeys here that are always active
; For example, you can add other hotkeys like this:

; Example hotkey:
; ^a::Send Hello, World!
