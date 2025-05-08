#!/usr/bin/env pwsh

param(
    [switch]$Brackets,
    [switch]$Extensions,
    [switch]$Spaces,
    [switch]$LowerCase,
    [switch]$Recursive,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Usage() {
    Write-Output @"
${MyInvocation.MyCommand.Name} : Handle files after they've been mauled by
           Windows Explorer file renaming

Arguments:
    -Brackets           remove brackets from the file
    -Extensions         normalise the file extensions
    -LowerCase          to lowercase
    -Recursive          act recursively
"@
    Exit 0
}

$currentDir = Get-Location
$searchOptions = ""

if (-not (($Brackets) `
    -or ($Extensions) `
    -or ($Spaces) `
    -or ($LowerCase))) {
    $Brackets = $true
    $Extensions = $true
    $Spaces = $true
    $LowerCase = $true
}

$searchOptions = $false
if ($Recursive) {
    $searchOptions = $true
}

gci -path $currentDir -file -Recurse:$searchOptions | foreach-object {
    $originalName = $_.Name
    $newName = $originalName

    if ($Brackets) {
        $newName = $newName -replace '\(', '' -replace '\)', ''
    }

    if ($Spaces) {
        $newName = $newName -replace ' ', '-'
    }

    if ($LowerCase) {
        $newName = $newName.ToLower()
    }

    if ($Extensions) {
        if ($newName -like "*.jpeg") {
            $newName = $newName -replace '\.jpeg$', '.jpg'
        }
        elseif ($newName -like "*.cmd") {
            $newName = $newName -replace '\.cmd$', '.bat'
        }
    }

    if ($newName -ne $originalName) {
        $newPath = Join-Path -Path $currentDir -ChildPath $newName
        if (-not ($DryRun)) {
            Rename-Item -Path $_.FullName -NewName $newName
        }
        Write-Host "    ->  $originalName  =>  $newName"
    }
}

# vi:shiftwidth=4
