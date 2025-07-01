# Test various scenarios that might cause 500 errors

Write-Host "=== Testing various error scenarios ==="

# Test 1: Invalid JSON
Write-Host "1. Testing invalid JSON..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer SinkCool"} -Body "invalid json" -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 2: Missing URL
Write-Host "2. Testing missing URL..."
$body = @{} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer SinkCool"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 3: Invalid URL
Write-Host "3. Testing invalid URL..."
$body = @{url = "not-a-valid-url"} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer SinkCool"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 4: Invalid slug (special characters)
Write-Host "4. Testing invalid slug..."
$body = @{url = "https://example.com"; slug = "invalid@slug!"} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer SinkCool"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 5: Wrong Authorization token
Write-Host "5. Testing wrong authorization token..."
$body = @{url = "https://example.com"} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer WrongToken"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 6: Missing Authorization header
Write-Host "6. Testing missing authorization header..."
$body = @{url = "https://example.com"} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host ""

# Test 7: Invalid expiration date
Write-Host "7. Testing invalid expiration date (past date)..."
$pastTimestamp = [int][double]::Parse((Get-Date -UFormat %s)) - 3600  # 1 hour ago
$body = @{url = "https://example.com"; expiration = $pastTimestamp} | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/link/create" -Method POST -Headers @{"Content-Type"="application/json"; "Authorization"="Bearer SinkCool"} -Body $body -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}
