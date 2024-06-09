# Windows Configuration Files

These used to live alongside my main
[Dotfiles](https://github.com/julianorchard/dotfiles), but I don't use Windows
enough to need them in there anymore.

## Scripts

Some of the scripts have descriptions and some of those descriptions are listed
below:

### cmdrc.bat <sup>[file](/scripts/cmdrc.bat)</sup>

This is a method of having a custom prompt in CMD. It's opened by AutoHotkey (see ahk/general.ahk for more information).

### commit.ps1 <sup>[file](/scripts/commit.ps1)</sup>

Should be thought of as a temporary tool until used to doing it by default! Reminder text from this Gist: https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716

### config.bat <sup>[file](/scripts/config.bat)</sup>

The command used to manage the bare repo: ```cmd git --git-dir=%HOME%/.dotfiles/ --work-tree=%HOME% ``` ... for use in the Windows CMD.

### drives.bat <sup>[file](/scripts/drives.bat)</sup>

Add shortcuts to available drives.

### ll.bat <sup>[file](/scripts/ll.bat)</sup>

`dir` isn't it my muscle memory at all.

### refreshprompt.bat <sup>[file](/scripts/refreshprompt.bat)</sup>

The main use case for this being whenever we change Git profiles. This isn't something I do as often as I used to.

### shortcuts.bat <sup>[file](/scripts/shortcuts.bat)</sup>

Use this script to create a shortcut to the current folder you're in. I've found this especially useful for CMD navigation.

### tidy <sup>[file](/scripts/tidy)</sup>

For tidying files after they've been mauled by Windows Explorer bulk renaming, e.g. "File (1).ext", ... Disclaimer, this is the first and only Ruby I've ever written

## License

[MTI](/LICENSE).
