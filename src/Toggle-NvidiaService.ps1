param (
    [switch]$SkipAdminCheck,
    [switch]$NoWait
)

# ============================================================
# Soporte para caracteres especiales (UTF-8)
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ============================================================
# Bloque de Auto-Elevación de Privilegios
# ============================================================
if (-not $SkipAdminCheck) {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        return
    }
}

# ============================================================
# Constantes
# ============================================================
$ServiceName = "FvSvc"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Alternar Servicio (Toggle) - $ServiceName" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$Servicio = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($null -eq $Servicio) {
    Write-Host "[!] El servicio $ServiceName no existe en el sistema." -ForegroundColor Red
    Start-Sleep -Seconds 3
    return
}

if ($Servicio.Status -eq 'Running') {
    Write-Host "[*] El servicio está ACTIVO. Deteniendo..." -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force
    Write-Host "[+] Servicio detenido exitosamente." -ForegroundColor Green
} else {
    Write-Host "[*] El servicio está DETENIDO. Iniciando..." -ForegroundColor Yellow
    Start-Service -Name $ServiceName
    Write-Host "[+] Servicio iniciado exitosamente." -ForegroundColor Green
}

Write-Host "============================================================"
if (-not $NoWait) {
    Write-Host "Cerrando en 3 segundos..."
    Start-Sleep -Seconds 3
}
