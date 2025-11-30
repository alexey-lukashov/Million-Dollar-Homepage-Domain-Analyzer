$content = Get-Content "./page.html" -Raw
$matches = [regex]::Matches($content, 'href="https?://([^/"]+)')
$domains = @{}
foreach ($m in $matches) {
    $domain = $m.Groups[1].Value
    if (-not $domains.ContainsKey($domain)) {
        $domains[$domain] = $true
    }
}
$domains.Keys | Sort-Object | ForEach-Object { Write-Output $_ }
