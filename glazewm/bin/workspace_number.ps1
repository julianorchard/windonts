$json = & glazewm.exe query workspaces | 
	ConvertFrom-Json

# TODO: this should actually call monitors and do similar but for a diff field (isVisible or something)
# $json.data.monitors $_.children $_.isDisplayed (multiple)
$focusedWorkspace = $json.data.workspaces | 
	Where-Object { $_.hasFocus -eq $true }

if ($focusedWorkspace -ne $null) {
    $workspaceName = $focusedWorkspace.name

    Start-Process -FilePath ".\tray.ahk" -ArgumentList $workspaceName
} else {
    Write-Error "No focused workspace found."
}
