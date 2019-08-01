param($originPath,$outPath)

#Firefox
$Uri = 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US'
$installerName = 'FF.msi'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\AsyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  Firefox has been installed!' -ForegroundColor DarkCyan

$regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe'
$appInstallPath = Get-ItemProperty -Path $regPath -Name 'Path' | Resolve-Path
$appInstallPath += 'firefox.exe'
Try {
    Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Create Shortcut.ps1') $appInstallPath ($originPath + '\Standardization\Shortcuts\Firefox.lnk')
} Catch {
    continue
}

Write-Host