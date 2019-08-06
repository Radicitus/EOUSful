param($originPath,$application)

$app = Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Utilities\string2array.ps1')

regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\'
$regPath += $app[0]
$regPath += '.exe'
$installed = Test-Path $regPath

If (-Not $installed) {
    $installPaths = @('C:\Program Files (x86)\','C:\Program Files\','C:\Users\confctr\AppData\Roaming\')
    ForEach ($installPath in $installPaths) {
        Try {
            Get-ChildItem -Path ($installPath)
        } Catch {

        }
    }
} Else {
    $match = Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Utilities\Check Shortcut.ps1') 'C:\Users\confctr\Desktop' $app[1]
}