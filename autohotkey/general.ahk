#Requires AutoHotkey v2.0+
#SingleInstance
DetectHiddenWindows true

; AHK: `CapsLock`; I usually switch `CapsLock` to `Ctrl`
CapsLock::Ctrl

; Home Path
global UserHome := "C:\Users\" A_UserName

; AHK: `Alt + Spacebar`; Toggles a windows "Always on top" status
^SPACE::WinsetAlwaysOnTop -1, WinGetTitle("A")

; AHK: `Volume_Up`/`Volume_Down`; Play a sound when volume up/down keys played
~Volume_Up::
~Volume_Down::SoundPlay("C:\Windows\Media\Windows Background.wav")

; AHK: `Alt + q`; Kill the current window
!q::WinKill(WinGetTitle("A"))

; AHK: `Alt + Enter`; Run my custom [`cmdrc.bat`](scripts/cmdrc.bat) file
$!Enter::
{
  if not WinActive("ahk_exe EXCEL.EXE")
  {
    Run(UserHome "\cmdrc.bat")
  }
  else
  {
    Send("!{enter}")
  }
}

; AHK: `Win + Enter`; Run PowersHell
#Enter::Run("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe")

; AHK: `Win + Alt + Enter`; Run Git Bash (how many of these do we need??)
#!Enter::Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Git\Git Bash")

; AHK: `Alt + c`; Get AutoHotkey `MouseMove X Y` positions to the clipboard (very useful for creating quick and dirty AHK scripts)
!c::
{
  MouseGetPos(&xpos, &ypos)
  A_Clipboard := "MouseMove(" xpos ",  " ypos ")"
}

; AHK: `PrintScreen`; Snipping tool
$PrintScreen::
{
  Run("C:\Windows\system32\SnippingTool.exe")
  if not WinWait("Snipping Tool", , 5)
  {
    MsgBox "Snipping tool timed out."
  }
  else
  {
    Send("^n")
  }
}

;; Function to return the coordinates of two points.
;; Used by !u::, underline, and !b::, box drawing
;; hotkeys, mainly alongside Snipping Tool
GetDrawingCoords()
{
  KeyWait("LButton", "D")
  MouseGetPos(&xa, &ya)

  KeyWait("LButton", "U")
  KeyWait("LButton", "D")
  MouseGetPos(&xb, &yb)

  ;; We reverse this here because we want to
  ;; draw the lines from the point the cursor
  ;; currently is, so b coords first (as they're
  ;; the second set) and then the a ones.
  c := [xb, yb, xa, ya]
  Return c
}

; AHK: `Alt + u`; Draw a line between the next two mouse clicks (U for Underline!)
!u::
{
  c := GetDrawingCoords()
  MouseClickDrag("L", c[1], c[2], c[3], c[4])
  MouseClickDrag("L", c[3], c[4], c[1], c[2])
}

; AHK: `Alt + b`; Draw a box between the next two mouse clicks (B for Box!!)
!b::
{
  ;; Although this doesn't matter which
  ;; points you click first, this is the
  ;; basic visualisation:

  ;;    x1,y1 --------------- x2,y1
  ;;      |                     |
  ;;      |                     |
  ;;      |                     |
  ;;      |                     |
  ;;    x1,y2 --------------- x2,y2

  c := GetDrawingCoords()
  x1 := c[1]
  y1 := c[2]
  x2 := c[3]
  y2 := c[4]

  ;; TODO:
  ;; I would like to do this in a loop,
  ;; but the MouseClickDrag doesn't want
  ;; to do that... might be able to use
  ;; something else instead.
  MouseClickDrag("L", x1, y1, x2, y1)
  Sleep(200)
  MouseClickDrag("L", x2, y1, x2, y2)
  Sleep(200)
  MouseClickDrag("L", x2, y2, x1, y2)
  Sleep(200)
  MouseClickDrag("L", x1, y2, x1, y1)
}

; TODO: Try making a solid fill box, could be interesting

; Line Break / <hr>'s - - - - - - - - - - - - - - -

; AHK: `Alt+=`; Insert  `-+-  -+-  -+-  -+-  -+-  -+-  -+-  -+-`
!=::
{
  Loop(8)
  {
    Send("{space}-{+}-{space}")
  }
}

; AHK: `Alt+~`; Insert  `-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-`
!#::
{
  Loop(16)
  {
    Send("-~")
  }
  Send("-")
}

; SignOff function inserts a random email signoff from an input file.
RandomFromFile(file)
{
  serious := []
  lines := 0
  Loop read, file
  {
    serious.Push(A_LoopReadLine)
    lines++
  }
  randomNumber := Random(0, lines)
  Return serious[randomNumber]
}

; AHK: `F7`; Insert a random "serious" email sign-off
!F7::Send(RandomFromFile(A_ScriptDir "\res\serious.txt"))

; AHK: `F8`; Insert a random "silly" email sign-off (I mostly keep both of these for nostalgia...)
!F8::Send(RandomFromFile(A_ScriptDir "\res\silly.txt") " regards, ")

; AHK: `F9`; Insert a random LinkedIn style message
!F9::Send(RandomFromFile(A_ScriptDir "res\linkedin.txt"))

; AHK: `F10`; Insert Lipsum text
!F10::Send(FileRead(A_ScriptDir "res\lipsum.txt") "{backspace 2}")

; AHK: `Alt+F12`; Hide the taskbar entirely
global taskbarStatus := false
$!F12::
{
  global taskbarStatus
  HideShowTaskbar(taskbarStatus := !taskbarStatus)
}
HideShowTaskbar(status)
{
  if (status)
  {
    ;; Set timer
    SetTimer(FixTaskbarHide, 500)
  }
  else
  {
    ;; Unset timer and show window
    SetTimer(FixTaskbarHide, 0)
    WinShow("ahk_class Shell_TrayWnd")
  }
}
FixTaskbarHide()
{
  ;; Check if the window is visible, using DllCall
  if DllCall("IsWindowVisible", "Ptr", WinExist("ahk_class Shell_TrayWnd"))
  {
    ;; If it is, hide it
    WinHide("ahk_class Shell_TrayWnd")
  }
}

; AHK: `Alt+i`; Toggle screen refresher (to bypass lockscreen timeouts, etc.)
Refresher()
{
  Send("{RAlt}")
}
global refresherStatus := false
!i::
{
  global refresherStatus
  refresherStatus := !refresherStatus
  if (refresherStatus)
  {
    TrayTip("Screen Refresher On", "The screen refresher has been enabled.")
    SetTimer(Refresher, 15000)
  }
  else
  {
    TrayTip("Screen Refresher Off", "The screen refresher has been disabled.")
    SetTimer(Refresher, 0)
  }
}
