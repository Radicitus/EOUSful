param($app,$checkShortcut)

regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\'
$regPath += $app
$regPath += '.exe'
$installed = Test-Path $regPath

If (-Not $installed) {
    $installPaths = @("C:\Program Files (x86)","C:\Program Files","C:\Users\confctr\AppData")
    ForEach ($installPath in $installPaths) {
        $path
        $paths = (Get-ChildItem -Path $installPath).FullName
        ForEach ($dirPath in $paths) {
            try {
                $path = (Get-ChildItem -Path $dirPath -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match ('^' + $app + '.exe$') }).FullName
                If (Test-Path $path) {
                    return $true
                }
            } catch { continue }
        }
    }
    return $false
}