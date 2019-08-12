param($shortcutDirectory,$appName)

$toReturn = $false
Try {
    Get-ChildItem $shortcutDirectory -Filter '*.lnk' |
            ForEach-Object {
                If ($appName -match $_.BaseName) {
                    $toReturn = $true
                }
            }
    return $toReturn
} Catch {
    Write-Host ' It seems the directory does not exist.' -ForegroundColor DarkRed
}