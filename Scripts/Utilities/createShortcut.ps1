param($sourceExecutable,$destinationPath)

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($destinationPath)
$Shortcut.TargetPath = $sourceExecutable
$Shortcut.Save()

Write-Host '  Shortcut created!' -ForegroundColor DarkCyan