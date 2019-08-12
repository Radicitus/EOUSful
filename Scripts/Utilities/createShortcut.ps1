param([Parameter(Mandatory=$True,Position = 0)] $sourceExecutable, [Parameter(Mandatory=$True,ValueFromRemainingArguments=$True,Position = 1)] $destinationPaths)

ForEach ($dPath in $destinationPaths) {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($dPath)
    $Shortcut.TargetPath = $sourceExecutable
    $Shortcut.Save()
    Write-Host '  Shortcut for ...'+  + ' placed at ...' + $dPath.substring($dPath.length - 5) + ' created!' -ForegroundColor DarkCyan
}