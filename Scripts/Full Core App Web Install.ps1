#Requires -RunAsAdministrator

param($originPath,$installList,$outPath)

$webInstallPath = $originPath + '\Scripts\Core App Web Installs\*'

Write-Host 'Beginning web installs...' -ForegroundColor Cyan

Get-ChildItem $webInstallPath | ForEach-Object {
    If ($installList -Match $_.BaseName) {
        Write-Host (' Starting ' + $_.BaseName + ' install...') -ForegroundColor DarkCyan
        Get-ChildItem -Path 'C:\Users\confctr\Desktop\*' -Include '*.lnk' | Where-Object { $_.Name.Contains($_.BaseName) } | Remove-Item
        Powershell.exe -executionpolicy remotesigned -File $_.FullName $originPath $outPath
    }
}

Write-Host 'Installations complete!' -ForegroundColor Cyan