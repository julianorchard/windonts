# NOTE: install.ps1 script copies this to $PROFILE - and
# 	./install.ps1 -nochoco  # speeds this up

$quickPaths = @(
    "C:\windonts",
    "\\wsl$\ubuntu\home\julian",
    "${env:USERPROFILE}\AppData\Local\nvim",
    "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Startup",
    "$HOME"
)

# Options
Set-PSReadlineOption -EditMode vi

# Aliases
set-alias -name ll -value get-childitem
remove-item Alias:ls
function ls
{
    param([switch]$la,[switch]$al)
    # don't actually mind whether the values are set... just
    get-childitem
    # satisfy the muscle memory
}
remove-item Alias:cd
function cd
{
    param([string]$path)
    if (-not $path)
    {
        set-location -path $HOME
    } else
    {
        set-location -path $path
    }
}
remove-item Alias:rm
function rm
{
    param(
        [switch]$r,
        [switch]$f,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$paths
    )

    if (-not $paths)
    {
        write-error "rm: missing item to remove"
        return
    }

    foreach ($path in $paths)
    {
        $args = @{
            path = $path
            ea = 'silentlycontinue'
        }

        if ($r)
        { $args.recurse = $true
        }
        if ($f)
        { $args.force = $true
        }

        remove-item @args
    }
}
function c
{
    $local:p = ( $quickPaths | fzf )
    if ($local:p -eq $null)
    {
        return
    } else
    {
        set-location $local:p
    }
}
