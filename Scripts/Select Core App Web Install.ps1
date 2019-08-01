#Requires -RunAsAdministrator

param($originPath,$installList,$outPath)

$webInstallPath = $originPath + '\Scripts\Core App Web Installs'

Write-Host 'Beginning web installs...' -ForegroundColor Cyan

Get-ChildItem $webInstallPath | ForEach-Object {
    If ($installList -Match $_.BaseName) {
        Get-ChildItem -Path 'C:\Users\confctr\Desktop\*' -Include '*.lnk' | Where-Object { $_.Name.Contains($_.BaseName) } | Remove-Item
        $prompt = New-Object -ComObject wscript.shell
        $selection = $prompt.popup(('Would you like to download and install ' + $_.BaseName + '?'), 5, 'Core Applications Web Install', 4)
        If ($selection -eq 6 -OR $selection -eq -1) {
            Write-Host (' Starting ' + $_.BaseName + ' install...') -ForegroundColor DarkCyan
            Powershell.exe -executionpolicy remotesigned -File $_.FullName $originPath $outPath
        }
    }
}

Write-Host 'Installations complete!' -ForegroundColor Cyan