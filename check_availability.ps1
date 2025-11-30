# Domain availability checker via DNS
param(
    [int]$Limit = 50,
    [int]$Start = 0
)

$domains = Get-Content "./root_domains.txt"
$available = @()
$taken = @()

$toCheck = $domains | Select-Object -Skip $Start -First $Limit

Write-Host "Checking $($toCheck.Count) domains..." -ForegroundColor Cyan
Write-Host ""

$i = 0
foreach ($domain in $toCheck) {
    $i++
    Write-Host "[$i/$($toCheck.Count)] $domain" -NoNewline

    try {
        $result = Resolve-DnsName -Name $domain -ErrorAction Stop -DnsOnly
        Write-Host " - TAKEN" -ForegroundColor Red
        $taken += $domain
    }
    catch {
        if ($_.Exception.Message -match "DNS name does not exist") {
            Write-Host " - POSSIBLY AVAILABLE!" -ForegroundColor Green
            $available += $domain
        } else {
            Write-Host " - ERROR" -ForegroundColor Yellow
        }
    }
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "========== RESULTS ==========" -ForegroundColor Cyan
Write-Host "Taken: $($taken.Count)" -ForegroundColor Red
Write-Host "Possibly available: $($available.Count)" -ForegroundColor Green

if ($available.Count -gt 0) {
    Write-Host ""
    Write-Host "Possibly available domains:" -ForegroundColor Green
    $available | ForEach-Object { Write-Host "  $_" }
    $available | Out-File "./domains_without_dns.txt"
}
