param([Parameter(Mandatory=$True,Position = 0)] $sourceExecutable, [Parameter(Mandatory=$True,Position = 1)] $app, [Parameter(Mandatory=$True,ValueFromRemainingArguments=$True,Position = 2)] $destinationPaths)

ForEach ($dPath in $destinationPaths) {

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($dPath + '\' + $app + '.lnk')
    $Shortcut.TargetPath = $sourceExecutable
    $Shortcut.Save()
    Write-Host ' Shortcut for "'$app' " placed at "' $dPath.substring($dPath.length - 10)'   " created!' -BackgroundColor DarkCyan
}