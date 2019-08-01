param($shortcutDirectory,$appName)

Try {
    Get-ChildItem $shortcutDirectory -Filter '*.lnk' |
            ForEach-Object {
                $shortcutName = Get-Content $_.BaseName
                If ($appName -match $shortcutName) {
                    exit $true
                }
            }
            return $false
} Catch {
    Write-Host ' It seems the directory does not exist.' -ForegroundColor DarkRed
}