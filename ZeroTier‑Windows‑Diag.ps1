<# 
    ZeroTier-Windows-Diag.ps1
    A diagnostic script for Windows Server 2022/2025 ZeroTier installations.
    Checks driver status, service status, Secure Boot, testsigning, firewall rules,
    event logs, and installation folder integrity.
#>

Write-Host "=== ZeroTier Windows Diagnostic Tool ===" -ForegroundColor Cyan
Write-Host ""

# --- Secure Boot Status ---
Write-Host "[1] Checking Secure Boot status..."
try {
    $secureBoot = Confirm-SecureBootUEFI
    Write-Host "    Secure Boot: $secureBoot"
} catch {
    Write-Host "    Secure Boot: Unable to determine (system may not support UEFI)"
}
Write-Host ""

# --- Testsigning Mode ---
Write-Host "[2] Checking testsigning mode..."
$bcd = bcdedit
$testsigning = ($bcd | Select-String "testsigning").ToString()
Write-Host "    $testsigning"
Write-Host ""

# --- ZeroTier Installation Folder ---
Write-Host "[3] Checking ZeroTier installation folder..."
$ztPath = "C:\Program Files\ZeroTier\One"
if (Test-Path $ztPath) {
    Write-Host "    Folder exists: $ztPath"
    $files = Get-ChildItem $ztPath
    Write-Host "    Files:"
    $files | ForEach-Object { Write-Host "      - $($_.Name)" }
} else {
    Write-Host "    ZeroTier folder not found."
}
Write-Host ""

# --- ZeroTier Service ---
Write-Host "[4] Checking ZeroTier service..."
$service = Get-Service -Name zerotierone -ErrorAction SilentlyContinue
if ($service) {
    Write-Host "    Service found: $($service.Status)"
} else {
    Write-Host "    Service not found."
}
Write-Host ""

# --- Driver Check ---
Write-Host "[5] Checking ZeroTier TAP driver..."
$driver = pnputil /enum-drivers | Select-String "ZeroTier"
if ($driver) {
    Write-Host "    Driver installed:"
    Write-Host "    $driver"
} else {
    Write-Host "    ZeroTier driver NOT installed."
}
Write-Host ""

# --- Firewall Rules ---
Write-Host "[6] Checking firewall rules..."
$fw = Get-NetFirewallRule | Select-String "ZeroTier"
if ($fw) {
    Write-Host "    Firewall rule found:"
    Write-Host "    $fw"
} else {
    Write-Host "    No ZeroTier firewall rule found."
}
Write-Host ""

# --- Event Log Scan ---
Write-Host "[7] Checking Setup event logs for driver errors..."
$events = Get-WinEvent -LogName Setup -MaxEvents 50 | Select-String "ZeroTier"
if ($events) {
    Write-Host "    Relevant Setup log entries:"
    Write-Host "    $events"
} else {
    Write-Host "    No ZeroTier-related Setup log entries found."
}
Write-Host ""

Write-Host "=== Diagnostic Complete ===" -ForegroundColor Green
