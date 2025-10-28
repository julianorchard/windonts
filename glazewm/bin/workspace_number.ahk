#Requires AutoHotkey v2.0

global popupGui := unset

ShowPopup(n) {
    global popupGui

    if IsSet(popupGui) {
        try popupGui.Destroy()
    }

    popupGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    popupGui.Add("Text", "Center w40 h40", n)

    left := top := right := bottom := 0
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)

    popupGui.Show("AutoSize Hide")
    WinGetPos(,, &guiWidth, &guiHeight, popupGui.Hwnd)

    x := right - guiWidth - 10
    y := bottom - guiHeight - 10

    popupGui.Show("x" x " y" y " NoActivate")
    SetTimer(() => popupGui.Destroy(), -1000)
}

; Get the first command-line argument
if A_Args.Length {
    ShowPopup(A_Args[1])
}
