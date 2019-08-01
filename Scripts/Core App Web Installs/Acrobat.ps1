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

$regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe'
$appInstallPath = Get-ItemProperty -Path $regPath -Name 'Path' | Resolve-Path
$appInstallPath += 'AcroRd32.exe'
Try {
    Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Create Shortcut.ps1') $appInstallPath ($originPath + '\Standardization\Shortcuts\Acrobat.lnk')
} Catch {
    continue
}

Write-Host