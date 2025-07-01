Write-Host "Testing API without CORS..."

$body = @{
    url = "https://github.com/ccbikai/Sink"
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer SinkCool"
}

try {
    Write-Host "Sending request to http://localhost:3000/api/link/create"
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers $headers -Body $body -UseBasicParsing -TimeoutSec 10
    Write-Host "✅ Success - Status: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "❌ Error occurred:"
    Write-Host "Exception: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    }
}
