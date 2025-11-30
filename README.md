# Million Dollar Homepage Domain Analyzer

Tools to extract and analyze domains from the famous [Million Dollar Homepage](http://www.milliondollarhomepage.com/) (2005-2006).

## What is this?

The Million Dollar Homepage was created by Alex Tew in 2005. The page sold 1,000,000 pixels for $1 each. Many of the original advertisers' domains are now expired or abandoned. This project helps identify which domains no longer have DNS records and could potentially be available for registration.

## Results Summary

- **Total domains extracted:** 2,737 (unique root domains)
- **Domains with DNS:** 2,462 (active)
- **Domains without DNS:** 169 (~6%) - potentially available

## Files

| File | Description |
|------|-------------|
| `page.html` | Archived Million Dollar Homepage |
| `domains.txt` | All domains extracted from the page |
| `root_domains.txt` | Cleaned root domains (no subdomains) |
| `domains_with_dns.txt` | Domains that resolve (active) |
| `domains_without_dns.txt` | Domains without DNS records |
| `domains_without_dns_with_coords.csv` | Domains without DNS + pixel coordinates and area |

## Top Domains Without DNS (by pixel area)

| Domain | Size | Area (px) | Coordinates |
|--------|------|-----------|-------------|
| epharma.md | 50x20 | 1000 | 110,420,160,440 |
| billigfluege.ag | 80x10 | 800 | 500,200,580,210 |
| creditcardbank.co.uk | 30x20 | 600 | 500,620,530,640 |
| mangosteen-zambroza.co.uk | 60x10 | 600 | 410,520,470,530 |
| stickernation.com | 50x10 | 500 | 110,550,160,560 |
| thecampbelldiet.com | 50x10 | 500 | 0,520,50,530 |
| savemoneygetmore.com | 20x20 | 400 | 850,270,870,290 |
| herbal-pillows.com | 20x20 | 400 | 0,900,20,920 |

## Scripts

### extract_domains.ps1
Extracts all unique domains from href attributes in the HTML.

### check_domains.ps1
Filters domains to root domains only, removing:
- Subdomains (www., blog., etc.)
- Placeholder entries
- Service domains (clickbank, doubleclick, etc.)

### check_availability.ps1
Checks domain DNS availability in batches.
```powershell
# Check first 50 domains
.\check_availability.ps1 -Limit 50 -Start 0
```

### check_all.ps1
Checks all domains and saves results to files.

### extract_with_coords.ps1
Extracts pixel coordinates and calculates area for domains without DNS.

## Usage

```powershell
# 1. Extract all domains
.\extract_domains.ps1 > domains.txt

# 2. Filter to root domains
.\check_domains.ps1 > root_domains.txt

# 3. Check DNS availability (takes ~5 min for all domains)
.\check_all.ps1

# 4. Extract coordinates for domains without DNS
.\extract_with_coords.ps1
```

## Important Notes

- **DNS check != WHOIS check** - A domain without DNS records may still be registered but not configured
- Always verify availability through a domain registrar before attempting to purchase
- Some domains may be in redemption period or reserved

## Disclaimer

This project is for educational and research purposes only. Domain availability should be verified through official registrars. The author is not responsible for any actions taken based on this data.

## License

MIT
