param($originPath,$outPath)

#Firefox
$Uri = 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US'
$installerName = 'FF.msi'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\asyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  Firefox has been installed!' -ForegroundColor DarkCyan

Write-Host