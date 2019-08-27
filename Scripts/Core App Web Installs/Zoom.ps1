param($originPath,$outPath)

$appName = 'Zoom'
#
$Uri = 'https://www.zoom.us/client/latest/ZoomInstallerFull.msi'
$installerName = 'ZM.msi'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\asyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  '$appName' has been installed!' -ForegroundColor DarkCyan

Write-Host