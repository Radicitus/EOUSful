param($originPath,$outPath)

#VLC
$Uri = 'https://download.videolan.org/pub/videolan/vlc/last/win64/’
$installerName = 'VLC.msi'

$installerPath = $outPath + '\' + $installerName
#
$Uri += ((Invoke-WebRequest –Uri ‘https://download.videolan.org/pub/videolan/vlc/last/win64/’ -UseBasicParsing).Links | Where-Object {$_.href -match "^vlc-(\d\.)+\d-win64\.msi$"}).href
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\AsyncDownload.ps1') $Uri $installerPath
Start-Process -FilePath $installerPath -ArgumentList '/qn' -Wait
Write-Host '  VLC has been installed!' -ForegroundColor DarkCyan

$regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\vlc.exe'
$appInstallPath = Get-ItemProperty -Path $regPath -Name 'Path' | Resolve-Path
$appInstallPath += 'vlc.exe'
Try {
    Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Create Shortcut.ps1') $appInstallPath ($originPath + '\Standardization\Shortcuts\VLC.lnk')
} Catch {
    continue
}

Write-Host