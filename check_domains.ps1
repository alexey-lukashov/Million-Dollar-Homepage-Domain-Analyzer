# Read domains and filter to root domains only
$domains = Get-Content "./domains.txt" | Where-Object {
    # Exclude placeholders and invalid entries
    $_ -notmatch '^%' -and
    $_ -notmatch '^reserved' -and
    $_ -notmatch '^Paid' -and
    $_ -notmatch '^Pending' -and
    $_ -notmatch '^Link' -and
    $_ -notmatch '^RESERVED' -and
    $_ -notmatch '^\.'
}

# Extract root domains (remove subdomains like www., blog., etc)
$rootDomains = @{}
foreach ($domain in $domains) {
    # Split into parts
    $parts = $domain -split '\.'

    # Determine root domain
    if ($parts.Count -ge 2) {
        # Check two-level TLDs (co.uk, com.au, etc)
        $lastTwo = "$($parts[-2]).$($parts[-1])"
        if ($lastTwo -match '^(co|com|org|net|ac|gov)\.(uk|au|nz|jp|br|in|za)$') {
            if ($parts.Count -ge 3) {
                $root = "$($parts[-3]).$lastTwo"
            } else {
                continue
            }
        } else {
            $root = "$($parts[-2]).$($parts[-1])"
        }

        # Exclude service domains
        if ($root -notmatch '(clickbank\.net|doubleclick\.net|typepad\.com|blogspot\.com|myspace\.com|geocities\.com|freeweb|hop\.|ez-signup)') {
            $rootDomains[$root] = $true
        }
    }
}

$rootDomains.Keys | Sort-Object | ForEach-Object { Write-Output $_ }
