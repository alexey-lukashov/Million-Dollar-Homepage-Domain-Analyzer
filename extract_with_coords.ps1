# Extract domains with coordinates and calculate area
$content = Get-Content "./page.html" -Raw

# Load available domains
$availableDomains = Get-Content "./domains_without_dns.txt" |
    ForEach-Object { $_.Trim() -replace '\s+', '' } |
    Where-Object { $_ -ne '' }

Write-Host "Loaded $($availableDomains.Count) available domains" -ForegroundColor Cyan

# Parse all area tags with coords and href
$pattern = '<area[^>]+coords="(\d+),(\d+),(\d+),(\d+)"[^>]+href="https?://([^/"]+)[^"]*"[^>]*>'
$matches = [regex]::Matches($content, $pattern)

Write-Host "Found $($matches.Count) area tags with coordinates" -ForegroundColor Cyan

$results = @()

foreach ($m in $matches) {
    $x1 = [int]$m.Groups[1].Value
    $y1 = [int]$m.Groups[2].Value
    $x2 = [int]$m.Groups[3].Value
    $y2 = [int]$m.Groups[4].Value
    $domain = $m.Groups[5].Value.ToLower()

    # Remove www. prefix for matching
    $domainClean = $domain -replace '^www\.', ''

    # Calculate dimensions and area
    $width = $x2 - $x1
    $height = $y2 - $y1
    $area = $width * $height

    # Check if domain is in available list
    $isAvailable = $false
    foreach ($avail in $availableDomains) {
        $availClean = ($avail -replace '^www\.', '').ToLower()
        if ($domainClean -eq $availClean -or $domain -eq $availClean) {
            $isAvailable = $true
            break
        }
    }

    if ($isAvailable) {
        $results += [PSCustomObject]@{
            Domain = $domain
            X1 = $x1
            Y1 = $y1
            X2 = $x2
            Y2 = $y2
            Width = $width
            Height = $height
            Area = $area
            Coords = "$x1,$y1,$x2,$y2"
        }
    }
}

# Sort by area descending
$sorted = $results | Sort-Object -Property Area -Descending

Write-Host ""
Write-Host "Found $($sorted.Count) available domains with coordinates" -ForegroundColor Green
Write-Host ""

# Output results
Write-Host "=" * 100
Write-Host ("{0,-45} {1,10} {2,10} {3,10} {4,20}" -f "DOMAIN", "WIDTH", "HEIGHT", "AREA(px)", "COORDS")
Write-Host "=" * 100

foreach ($r in $sorted) {
    Write-Host ("{0,-45} {1,10} {2,10} {3,10} {4,20}" -f $r.Domain, $r.Width, $r.Height, $r.Area, $r.Coords)
}

# Save to CSV
$sorted | Export-Csv -Path "./domains_without_dns_with_coords.csv" -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Results saved to domains_without_dns_with_coords.csv" -ForegroundColor Green
