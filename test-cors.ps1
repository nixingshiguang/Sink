# Test CORS preflight request
$headers = @{
    "Origin" = "https://example.com"
    "Access-Control-Request-Method" = "POST"
    "Access-Control-Request-Headers" = "Content-Type,Authorization"
}

Write-Host "Testing CORS preflight request..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method OPTIONS -Headers $headers -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Headers:"
    foreach ($header in $response.Headers.GetEnumerator()) {
        if ($header.Key -like "*Access-Control*") {
            Write-Host "  $($header.Key): $($header.Value)"
        }
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
}

Write-Host ""
Write-Host "Testing actual POST request with Origin header..."

# Test actual request with Origin header
$body = @{
    url = "https://example.com"
    slug = "test-cors"
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer SinkCool"
    "Origin" = "https://example.com"
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers $headers -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "CORS Headers:"
    foreach ($header in $response.Headers.GetEnumerator()) {
        if ($header.Key -like "*Access-Control*") {
            Write-Host "  $($header.Key): $($header.Value)"
        }
    }
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
}
