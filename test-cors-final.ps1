# Final CORS test with unique slug
Write-Host "=== Final CORS Test ==="

# Test CORS preflight request
Write-Host "1. Testing CORS preflight request..."
$headers = @{
    "Origin" = "https://example.com"
    "Access-Control-Request-Method" = "POST"
    "Access-Control-Request-Headers" = "Content-Type,Authorization"
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method OPTIONS -Headers $headers -UseBasicParsing
    Write-Host "✅ Preflight Success - Status: $($response.StatusCode)"
    Write-Host "CORS Headers:"
    foreach ($header in $response.Headers.GetEnumerator()) {
        if ($header.Key -like "*Access-Control*") {
            Write-Host "  $($header.Key): $($header.Value)"
        }
    }
} catch {
    Write-Host "❌ Preflight Error: $($_.Exception.Message)"
}

Write-Host ""

# Test actual request with unique slug
Write-Host "2. Testing actual POST request with unique slug..."
$timestamp = [int][double]::Parse((Get-Date -UFormat %s))
$body = @{
    url = "https://example.com/test"
    slug = "cors-test-$timestamp"
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer SinkCool"
    "Origin" = "https://example.com"
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers $headers -Body $body -UseBasicParsing
    Write-Host "✅ POST Success - Status: $($response.StatusCode)"
    Write-Host "CORS Headers:"
    foreach ($header in $response.Headers.GetEnumerator()) {
        if ($header.Key -like "*Access-Control*") {
            Write-Host "  $($header.Key): $($header.Value)"
        }
    }
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "❌ POST Error: $($_.Exception.Message)"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
}

Write-Host ""
Write-Host "=== CORS Test Complete ==="
