[CmdletBinding()]
param (
    [string]$TargetDirName = "FFVIIRB-Nvidia-FrameView-Toggle",
    [string]$ShortcutName = "FFVII Rebirth (FrameView Toggle)"
)

# ============================================================
# Soporte para caracteres especiales (UTF-8)
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Desinstalador - FFVIIRB Nvidia FrameView Toggle" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

Write-Host "[*] Iniciando desinstalación..." -ForegroundColor Cyan

# 1. Limpiar acceso directo
$DesktopPath = [Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path -Path $DesktopPath -ChildPath "$ShortcutName.lnk"
if (Test-Path -Path $ShortcutPath) {
    Remove-Item -Path $ShortcutPath -Force
    Write-Host "[+] Eliminado acceso directo: $ShortcutPath" -ForegroundColor Green
}
else {
    Write-Host "[-] El acceso directo no existe: $ShortcutPath" -ForegroundColor Yellow
}

# 2. Limpiar carpeta de instalación
$TargetDir = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\My Games\FINAL FANTASY VII REBIRTH\$TargetDirName"
if (Test-Path -Path $TargetDir) {
    # Cambiar al directorio del usuario para evitar bloqueos si el script se ejecuta desde TargetDir
    Set-Location -Path $env:USERPROFILE
    Remove-Item -Path $TargetDir -Recurse -Force
    Write-Host "[+] Eliminado directorio de instalación: $TargetDir" -ForegroundColor Green
}
else {
    Write-Host "[-] El directorio de instalación no existe: $TargetDir" -ForegroundColor Yellow
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "[+] Desinstalación completada con éxito." -ForegroundColor Green
Write-Host "Saliendo en 5 segundos..."
Start-Sleep -Seconds 5
