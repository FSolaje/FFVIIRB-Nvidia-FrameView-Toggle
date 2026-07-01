param (
    [switch]$SkipAdminCheck
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
        exit
    }
}

# ============================================================
# Constantes
# ============================================================
$ServiceName  = "FvSvc"
$ProcessName  = "ff7rebirth"
$AppPathOrURI = "steam://rungameid/2909400"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Optimizador de Interfaz - Final Fantasy VII Rebirth" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Comprobar el estado actual del servicio
$Servicio = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($null -ne $Servicio -and $Servicio.Status -eq 'Running') {
    Write-Host "[*] El servicio de telemetría está activo. Aplicando fix..." -ForegroundColor Yellow
    
    # 1. Detener (llamando al script de toggle)
    $ToggleScript = Join-Path -Path $PSScriptRoot -ChildPath "Toggle-NvidiaService.ps1"
    & $ToggleScript -SkipAdminCheck -NoWait
    
    # 2. Lanzar Juego
    Write-Host "[*] Iniciando el juego ($AppPathOrURI)..."
    Start-Process $AppPathOrURI
    
    # 3. Monitorizar
    Write-Host "[*] Esperando a que arranque el ejecutable ($ProcessName)..."
    while (-not (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 2 }
    
    Write-Host "[*] Juego en curso. Esperando cierre..." -ForegroundColor Yellow
    Wait-Process -Name $ProcessName -ErrorAction SilentlyContinue
    
    # 4. Restaurar (llamando al script de toggle)
    Write-Host "[*] Juego cerrado. Restaurando servicio $ServiceName..." -ForegroundColor Green
    & $ToggleScript -SkipAdminCheck -NoWait
} 
else {
    # Si el servicio ya está detenido o no existe
    Write-Host "[*] El servicio $ServiceName no está en ejecución o no existe." -ForegroundColor Green
    Write-Host "[*] No es necesario aplicar el fix. Iniciando el juego directamente..."
    
    Start-Process $AppPathOrURI
}

Write-Host "============================================================"
Write-Host "  Lanzamiento completado. Cerrando en 3 segundos..."
Start-Sleep -Seconds 3
