Get-Content C:\EaseOfUse\DesktopOK_x64\DesktopOK.xml | ForEach-Object { $_ -replace "DESKTOP-1KFM7O1", $env:computername } | Set-Content C:\EaseOfUse\DesktopOK_x64\DesktopOK_copy.xml
Remove-Item -Path C:\EaseOfUse\DesktopOK_x64\DesktopOK.xml
Rename-Item -Path C:\EaseOfUse\DesktopOK_x64\DesktopOK_copy.xml -NewName "DesktopOK.xml"