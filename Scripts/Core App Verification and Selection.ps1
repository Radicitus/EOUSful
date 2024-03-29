﻿param($originPath=($PSScriptRoot -Replace '.\Scripts'))

Write-Host 'Core Application Verification and Web Install' -ForegroundColor Green
Write-Host '---------------------------------------------' -ForegroundColor Green

$applications = ('firefox','Firefox'),('chrome','Chrome'),('vlc','VLC'),('AcroRd32','Acrobat'),('zoom','Zoom')
$installList = @()
$transformedInstallList = ''

ForEach ($app in $applications) {
    $installed = Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Utilities\isInstalled.ps1') $app[0]
    If (-Not $installed[0]) {
        $installList += $app[1]
    } Else {
        $hasShortcut = Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\checkShortcut.ps1') 'C:\Users\confctr\Desktop' $app[1]
        If (-Not $hasShortcut) {
                Write-Host ' Creating shortcut for '$app[1]'...' -ForegroundColor DarkCyan
                Try {
                    Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\createShortcut.ps1') $installed[1] $app[1] 'C:\Users\confctr\Desktop\' ($originPath + '\Standardization\Shortcuts\')
                } Catch {
                    Write-Host '  It seems the account "Confctr" is not available on this computer.' -ForegroundColor Red
                }
        }
    }
}

If ($installList.count -eq 0) {
    Write-Host 'All core applications are installed!'
    Write-Host
} Else {
    Write-Host 'The following applications are not installed or could not be located:'
    ForEach ($app in $installList) {
        Write-Host ' '$app -ForegroundColor Red
        $transformedInstallList += $app
    }
    Write-Host

    If (Test-Path ($originPath + '\Standardization\Applications')) {
        $defaultPath = $true
        $outPath = $originPath + '\Standardization\Applications'
    } Else {
        $defaultPath = $false
        New-Item -Path ($originPath + '\') -Name 'Temp' -ItemType 'directory' -Force | Out-Null
        $outPath = $originPath + '\Temp'
    }

    $prompt = New-Object -ComObject wscript.shell
    $selection = $prompt.popup('Would you like to select certain applications?', 5, 'Core Applications Web Install', 3)
    If ($selection -eq 6) {
        Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Select Core App Web Install.ps1') $originPath $transformedInstallList $outPath
    }
    If ($selection -eq 7 -OR $selection -eq -1) {
        Powershell.exe -executionpolicy remotesigned -File ($originPath + '\Scripts\Full Core App Web Install.ps1') $originPath $transformedInstallList $outPath
    }
    If ($selection -eq 2) {
        exit 69
    }

    If ($defaultPath) {
        Remove-Item -Path ($outPath + '\*') -Recurse
    } Else {
        Remove-Item -Path $outpath -Recurse
    }

    Write-Host

}