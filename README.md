# Windows Configuration Files

These used to live alongside my main
[Dotfiles](https://github.com/julianorchard/dotfiles), but I don't use Windows
enough, as a desktop, to need it in the same repo.

## Scripts

Some of the scripts have descriptions and some of those descriptions are listed
below:

<!--begin scripts-->

### config.bat

The command used to manage the bare repo:  ```cmd git --git-dir=%HOME%/.dotfiles/ --work-tree=%HOME% ```  ... for use in the Windows CMD.

### shortcuts.bat

Use this script to create a shortcut to the current folder you're in. I've found this especially useful for CMD navigation.

### tidy.ps1

For tidying files after they've been mauled by Windows Explorer bulk renaming, e.g. "File (1).ext", ...  Originally written in Ruby for some reason.

### cmdrc.bat

This is a method of having a custom prompt in CMD. It's opened by AutoHotkey (see ahk/general.ahk for more information).

### ll.bat

`dir` isn't it my muscle memory at all.

### drives.bat

Add shortcuts to available drives.

<!--end scripts-->

## AutoHotkey

I have a number of fun and useful AutoHotkey settings (requires version v2.0).

<!--begin ahk_mapping-->
| Keys | Description | File  |
| --- | --- | ---  |
| `CapsLock` | I usually switch `CapsLock` to `Ctrl` | [general.ahk](autohotkey/general.ahk)  |
| `Alt + Spacebar` | Toggles a windows "Always on top" status | [general.ahk](autohotkey/general.ahk)  |
| `Volume_Up`/`Volume_Down` | Play a sound when volume up/down keys played | [general.ahk](autohotkey/general.ahk)  |
| `Alt + q` | Kill the current window | [general.ahk](autohotkey/general.ahk)  |
| `Alt + Enter` | Run my custom [`cmdrc.bat`](scripts/cmdrc.bat) file | [general.ahk](autohotkey/general.ahk)  |
| `Win + Enter` | Run PowersHell | [general.ahk](autohotkey/general.ahk)  |
| `Win + Alt + Enter` | Run Git Bash (how many of these do we need??) | [general.ahk](autohotkey/general.ahk)  |
| `Alt + c` | Get AutoHotkey `MouseMove X Y` positions to the clipboard (very useful for creating quick and dirty AHK scripts) | [general.ahk](autohotkey/general.ahk)  |
| `PrintScreen` | Snipping tool | [general.ahk](autohotkey/general.ahk)  |
| `Alt + u` | Draw a line between the next two mouse clicks (U for Underline!) | [general.ahk](autohotkey/general.ahk)  |
| `Alt + b` | Draw a box between the next two mouse clicks (B for Box!!) | [general.ahk](autohotkey/general.ahk)  |
| `Alt+=` | Insert  `-+-  -+-  -+-  -+-  -+-  -+-  -+-  -+-` | [general.ahk](autohotkey/general.ahk)  |
| `Alt+~` | Insert  `-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-` | [general.ahk](autohotkey/general.ahk)  |
| `F7` | Insert a random "serious" email sign-off | [general.ahk](autohotkey/general.ahk)  |
| `F8` | Insert a random "silly" email sign-off (I mostly keep both of these for nostalgia...) | [general.ahk](autohotkey/general.ahk)  |
| `F9` | Insert a random LinkedIn style message | [general.ahk](autohotkey/general.ahk)  |
| `F10` | Insert Lipsum text | [general.ahk](autohotkey/general.ahk)  |
| `Alt+F12` | [general.ahk](autohotkey/general.ahk)  |
| `Alt+i` | Toggle screen refresher (to bypass lockscreen timeouts, etc.) | [general.ahk](autohotkey/general.ahk)  |

<!--end ahk_mapping-->

## Glaze WM

I've recently started using Glaze when on Windows for a longer period
of time. This is the newest part of my configuration with the most
updates.

<!--begin glazewm_mapping-->
<!--end glazewm_mapping-->

## License

[MIT](/LICENSE).
