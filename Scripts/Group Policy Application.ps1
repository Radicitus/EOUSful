#Requires -RunAsAdministrator

param($originPath)

Write-Host 'Install Group Policy' -ForegroundColor Green
Write-Host '--------------------' -ForegroundColor Green
Write-Host

$gpPath = $originPath + '\Group Policy'
$installerPath = $gpPath + '\LGPO.exe'
$configPath = $gpPath + '\gpoconf'

Write-Host ' Beginning application of Group Policy...' -ForegroundColor Cyan
Try {
    Start-Process -FilePath $installerPath -ArgumentList '/q /g $configPath' -Wait
    Write-Host ' Application complete!' -ForegroundColor Cyan
} Catch {
    Write-Host '  Group Policy application has failed.' -ForegroundColor Red 
}
