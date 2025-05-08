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
#f::g("toggle-fullscreen")
#m::g("toggle-minimized")
#q::g("close")
#+e::g("wm-exit")
#+r::g("wm-reload-config")
#Enter::g("shell-exec wt")
#r::g("wm-enable-binding-mode --name resize")


; Modifier (numbered) keys
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
    ; Alt + direction
    Hotkey("!" . item.vi, (*) => g("focus --direction " . item.dir))
    Hotkey("!" . item.arrow, (*) => g("focus --direction " . item.dir))

    ; Alt + Shift + direction
    Hotkey("!+" . item.vi, (*) => g("move --direction " . item.dir))
    Hotkey("!+" . item.arrow, (*) => g("move --direction " . item.dir))
}
