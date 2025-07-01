$body = @{
    url = "https://github.com/ccbikai/Sink"
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer SinkCool"
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers $headers -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Response: $($_.Exception.Response)"
}
