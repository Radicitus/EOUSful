param($originPath,$outPath)

#Acrobat
$Uri = 'https://admdownload.adobe.com/bin/live/readerdc_en_xa_crd_install.exe'
$installerName = 'readerdc_en_xa_crd_install.exe'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\AsyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath
Start-Sleep -Seconds 180
Write-Host '  Acrobat has been installed!' -ForegroundColor DarkCyan

Write-Host