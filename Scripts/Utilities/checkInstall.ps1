param($app)

regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\'
$regPath += $app[0]
$regPath += '.exe'
$installed = Test-Path $regPath

If (-Not $installed) {
    return $false
} Else {
    $match = Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Utilities\Check Shortcut.ps1') 'C:\Users\confctr\Desktop' $app[1]
}