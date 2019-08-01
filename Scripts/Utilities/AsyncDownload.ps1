param($SourceUrl,$DestinationPath)

$WebClient = New-Object -TypeName System.Net.WebClient
$Global:IsDownloaded = $false
$SplatArgs = @{ InputObject = $WebClient
                EventName = 'DownloadFileCompleted'
                Action = { $Global:IsDownloaded = $true } }
$DownloadCompletedEventSubscriber = Register-ObjectEvent @SplatArgs
$WebClient.DownloadFileAsync("$SourceUrl","$DestinationPath")
while (-not $Global:IsDownloaded) {
    Start-Sleep -Seconds 3
}
Unregister-Event -SubscriptionId $DownloadCompletedEventSubscriber.Id
$DownloadCompletedEventSubscriber.Dispose()
$WebClient.Dispose()