# Check ALL domains and save results
$domains = Get-Content "./root_domains.txt"
$available = @()
$taken = @()

Write-Host "Checking $($domains.Count) domains. This will take a while..." -ForegroundColor Cyan
Write-Host ""

$i = 0
foreach ($domain in $domains) {
    $i++
    if ($i % 100 -eq 0) {
        Write-Host "Progress: $i / $($domains.Count) - Found $($available.Count) available so far" -ForegroundColor Cyan
    }

    try {
        $result = Resolve-DnsName -Name $domain -ErrorAction Stop -DnsOnly
        $taken += $domain
    }
    catch {
        if ($_.Exception.Message -match "DNS name does not exist") {
            Write-Host "AVAILABLE: $domain" -ForegroundColor Green
            $available += $domain
        }
    }
    Start-Sleep -Milliseconds 50
}

Write-Host ""
Write-Host "========== FINAL RESULTS ==========" -ForegroundColor Cyan
Write-Host "Total checked: $($domains.Count)"
Write-Host "Taken: $($taken.Count)" -ForegroundColor Red
Write-Host "Possibly available: $($available.Count)" -ForegroundColor Green

# Save results
$available | Out-File "./domains_without_dns.txt" -Force
$taken | Out-File "./domains_with_dns.txt" -Force

Write-Host ""
Write-Host "Results saved to domains_without_dns.txt and domains_with_dns.txt"
