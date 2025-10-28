@echo off

:: This is written in DOS-Batch to avoid any issues with execution-policy on a
:: fresh Windows machine

:: Set the config base directory
set "BASE_DIR=C:\windonts"

:: Prefix commands with `start "" ` so that the process is detached

echo "Starting glazewm.exe ^(will halt existing instance^)..."
taskkill /IM glazewm.exe /F
start "GlazeWM" glazewm.exe start -c "%BASE_DIR%\glazewm\config.yaml"

echo "Starting general.ahk..."
start "GeneralAHK" "%BASE_DIR%\autohotkey\general.ahk"
