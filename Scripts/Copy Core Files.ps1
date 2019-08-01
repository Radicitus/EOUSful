param($originPath)

Write-Host 'Copy Over Required Files for Installation' -ForegroundColor Green
Write-Host '-----------------------------------------' -ForegroundColor Green
Write-Host


Write-Host 'Beginning copy process...' -ForegroundColor Cyan

Write-Host ' Copying over EaseOfUse folder to root directory...' -ForegroundColor DarkCyan
Copy-Item ($originPath + '\EaseOfUse') 'C:\EaseOfUse'
Write-Host '  Copying complete!' -ForegroundColor DarkCyan
Write-Host




