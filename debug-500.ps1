# Debug script for 500 errors in Sink API

Write-Host "=== Sink API 500 Error Debugging ==="
Write-Host ""

# Function to test API endpoint
function Test-API {
    param(
        [string]$Url,
        [string]$Token,
        [hashtable]$Body,
        [string]$Description
    )
    
    Write-Host "Testing: $Description"
    Write-Host "URL: $Url"
    Write-Host "Body: $($Body | ConvertTo-Json -Compress)"
    
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $Token"
        "Origin" = "https://example.com"
    }
    
    try {
        $jsonBody = $Body | ConvertTo-Json
        $response = Invoke-WebRequest -Uri $Url -Method POST -Headers $headers -Body $jsonBody -UseBasicParsing
        Write-Host "✅ Success - Status: $($response.StatusCode)"
        Write-Host "Response: $($response.Content)"
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "❌ Error - Status: $statusCode"
        Write-Host "Error: $($_.Exception.Message)"
        
        # Try to get response content for more details
        try {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $responseBody = $reader.ReadToEnd()
            if ($responseBody) {
                Write-Host "Response Body: $responseBody"
            }
        }
        catch {
            Write-Host "Could not read response body"
        }
    }
    Write-Host "---"
    Write-Host ""
}

# Get API URL from user
$apiUrl = Read-Host "Enter your API URL (e.g., https://your-domain.com/api/link/create or http://localhost:3000/api/link/create)"
if (-not $apiUrl) {
    $apiUrl = "http://localhost:3000/api/link/create"
    Write-Host "Using default: $apiUrl"
}

# Get token from user
$token = Read-Host "Enter your site token (default: SinkCool)"
if (-not $token) {
    $token = "SinkCool"
    Write-Host "Using default token: $token"
}

Write-Host ""

# Test 1: Basic valid request
Test-API -Url $apiUrl -Token $token -Body @{url = "https://github.com/ccbikai/Sink"} -Description "Basic valid request"

# Test 2: With custom slug
Test-API -Url $apiUrl -Token $token -Body @{url = "https://example.com"; slug = "test-debug"} -Description "Request with custom slug"

# Test 3: With all optional fields
Test-API -Url $apiUrl -Token $token -Body @{
    url = "https://example.com/test"
    slug = "full-test"
    comment = "Test comment"
    title = "Test Title"
    description = "Test Description"
} -Description "Request with all optional fields"

# Test 4: With future expiration
$futureTimestamp = [int][double]::Parse((Get-Date -UFormat %s)) + 3600  # 1 hour from now
Test-API -Url $apiUrl -Token $token -Body @{
    url = "https://example.com/expire"
    expiration = $futureTimestamp
} -Description "Request with future expiration"

Write-Host "=== Debugging Complete ==="
Write-Host ""
Write-Host "If you're still getting 500 errors, check:"
Write-Host "1. Cloudflare KV namespace is properly configured"
Write-Host "2. Environment variables are set correctly"
Write-Host "3. Check server logs for detailed error messages"
Write-Host "4. Ensure you're using the correct site token"
Write-Host ""
Write-Host "For production deployment on Cloudflare:"
Write-Host "- Make sure KV namespace is bound in wrangler.jsonc"
Write-Host "- Check Cloudflare Workers environment variables"
Write-Host "- Verify the site token matches your configuration"
