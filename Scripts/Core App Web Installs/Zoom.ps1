﻿param($originPath,$outPath)

#Zoom
$Uri = 'https://www.zoom.us/client/latest/ZoomInstallerFull.msi'
$installerName = 'ZM.msi'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\AsyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  Zoom has been installed!' -ForegroundColor DarkCyan

Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Create Shortcut.ps1') 'C:\Program Files (x86)\Zoom\bin\zoom.exe' ($originPath + '\Standardization\Shortcuts\Zoom.lnk')

Write-Host