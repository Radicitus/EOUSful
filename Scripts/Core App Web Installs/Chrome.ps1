param($originPath,$outPath)

#Chrome
$Uri = 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B6AB92D79-4867-7092-013D-B9BC7E60A3C2%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe'
$installerName = 'CHR.exe'

$installerPath = $outPath + '\' + $installerName
#
Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\AsyncDownload.ps1') $Uri $installerPath
Try {
    Start-Process -FilePath $installerPath -Wait
    Write-Host '  Chrome has been installed!' -ForegroundColor DarkCyan
} Catch {
    Write-Host '  Chrome download link has expired, or some other issue.' -ForegroundColor DarkRed
}

Write-Host