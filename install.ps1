#!/usr/bin/env pwsh
# vi:shiftwidth=4
#requires -runasadministrator

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Set-ExecutionPolicy bypass -scope process -force

if (-not (get-command choco -erroraction silentlycontinue)) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    invoke-expression ((new-object system.net.webclient).downloadstring('https://community.chocolatey.org/install.ps1'))
}

if (-not (test-path "./packages.config")) {
    write-error "No chocolatey packages.config file found in the current directory (check it's there!)"
}

choco install -y packages.config

function Move-ItemWrapper {
    param(
	[string]$from,
	[string]$to,
	[string]$niceto
    )
    if ($niceto -ne $null) {
	write-host "Moving $from to $niceto"
    }
    else {
	write-host "Moving $from to $to"
    }
    copy-item $from $to
}

Move-ItemWrapper profile.ps1 $PROFILE "the powershell profile location"
Move-ItemWrapper wt.json $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json "the horrible windows terminal settings place"
Move-ItemWrapper startup.ps1 "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Startup" "the horrible startup dir"
