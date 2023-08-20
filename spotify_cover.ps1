Add-Type -AssemblyName System.Windows.Forms
$clientID = "client_id_here"
$clientSecret = "client_secret_here"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("${clientID}:${clientSecret}")))
$response = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri "https://accounts.spotify.com/api/token" -Method Post -Body @{grant_type="client_credentials"}
$token = $response.access_token
$headers = @{"Authorization" = "Bearer $token"}

$clipboardContent = [System.Windows.Forms.Clipboard]::GetText()

if ($clipboardContent -match "https://open.spotify.com/track/") {
    $trackUrl = $clipboardContent
} else {
    $trackUrl = Read-Host "Paste clipboard"
}

$trackId = $trackUrl.Split("/")[-1].Split("?")[0]
$trackData = Invoke-RestMethod -Headers $headers -Uri ("https://api.spotify.com/v1/tracks/" + $trackId)

$coverUrl = $trackData.album.images[0].url

Invoke-WebRequest $coverUrl -OutFile cover.jpg

Write-Host "saved as cover.jpg"