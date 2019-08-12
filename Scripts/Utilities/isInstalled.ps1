param($app)

regPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\'
$regPath += $app
$regPath += '.exe'
$installed = Test-Path $regPath
$toReturn = @()

$path
If ($installed) {
    $path = Get-ItemProperty -Path $regPath -Name 'Path' | Resolve-Path
    $path += ($app[0] + '.exe')
    $toReturn += $true
    $toReturn += $path
    return $toReturn
} Else {
    $installPaths = @("C:\Program Files (x86)","C:\Program Files","C:\Users\confctr\AppData")
    ForEach ($installPath in $installPaths) {
        $paths = (Get-ChildItem -Path $installPath).FullName
        ForEach ($dirPath in $paths) {
            try {
                $path = (Get-ChildItem -Path $dirPath -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match ('^' + $app + '.exe$') }).FullName
                If (Test-Path $path) {
                    $toReturn += $true
                    $toReturn += $path
                    return $toReturn
                }
            } catch { continue }
        }
    }
    $toReturn += $false
    return $toReturn
}

