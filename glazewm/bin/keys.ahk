#Requires AutoHotkey v2.0+
#SingleInstance

; Run the glaze command but hide the command line which actually makes the call
g(cmd) {
    Run "glazewm command " cmd,, "Hide"
}

ws_focus(key) {
    return (*) => g("focus --workspace " . key)
}

ws_move(key) {
    return (*) => g("move --workspace " . key)
}

; General keys
; GLZ: `Super+f`; Fullscreen
#f::g("toggle-fullscreen")
; GLZ: `Super+m`; Toggle minimized window
#m::g("toggle-minimized")
; GLZ: `Super+q`; Close window
#q::g("close")
; GLZ: `Super+Shift+e`; Close GlazeWM
#+e::g("wm-exit")
; GLZ: `Super+Shift+r`; Reload GlazeWM (including keymappings)
#+r::g("wm-reload-config")
; GLZ: `Super+Enter`; Execute the Windows Terminal
#Enter::g("shell-exec wt")
; GLZ: `Super+r`; Enter resize mode **(TODO: Make better!)**
#r::g("wm-enable-binding-mode --name resize")


; GLZ: `Super+[0-9]`; Switch to nth workspace
; GLZ: `Super+Shift+[0-9]`; Move window to nth workspace
Loop 9 {
    key := A_Index
    Hotkey("#" . key, ws_focus(key))
    Hotkey("#+" . key, ws_move(key))
}

; Arrow key movements
directions := [
    {dir: "left", vi: "h", arrow: "Left"},
    {dir: "down", vi: "j", arrow: "Down"},
    {dir: "up", vi: "k", arrow: "Up"},
    {dir: "right", vi: "l", arrow: "Right"},
]

for item in directions {
    ; GLZ: `Alt+[hjkl\|Left+Down+Up+Right]`; Move focus directionally
    Hotkey("!" . item.vi, (*) => g("focus --direction " . item.dir))
    Hotkey("!" . item.arrow, (*) => g("focus --direction " . item.dir))

    ; GLZ: `Alt+Shift+[hjkl\|Left+Down+Up+Right]`; Move window directionally
    Hotkey("!+" . item.vi, (*) => g("move --direction " . item.dir))
    Hotkey("!+" . item.arrow, (*) => g("move --direction " . item.dir))
}
