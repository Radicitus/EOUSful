param($originPath,$outPath)

$appName = 'VLC'
#
$Uri = 'https://download.videolan.org/pub/videolan/vlc/last/win64/’
$installerName = 'VLC.msi'

$installerPath = $outPath + '\' + $installerName
#
$Uri += ((Invoke-WebRequest –Uri ‘https://download.videolan.org/pub/videolan/vlc/last/win64/’ -UseBasicParsing).Links | Where-Object {$_.href -match "^vlc-(\d\.)+\d-win64\.msi$"}).href
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\asyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  '$appName' has been installed!' -ForegroundColor DarkCyan

Write-Host