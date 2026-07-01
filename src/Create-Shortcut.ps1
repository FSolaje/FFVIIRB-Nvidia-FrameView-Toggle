[CmdletBinding()]
param (
    [string]$ShortcutName = "FFVII Rebirth (FrameView Toggle)"
)

# ============================================================
# Soporte para caracteres especiales (UTF-8)
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Generador de Acceso Directo - FFVIIRB Toggle" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$IconPath = "C:\Program Files (x86)\Steam\steam\games\d3697ce75022287b2c209e61eaf280b8b6cdec31.ico"

$DesktopPath = [Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path -Path $DesktopPath -ChildPath "$ShortcutName.lnk"

# Crear el objeto COM para Accesos Directos
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# El ejecutable es powershell, para que arranque oculto
$Shortcut.TargetPath = "powershell.exe"

# Argumentos: -WindowStyle Hidden -ExecutionPolicy Bypass -File "RutaAlLauncher.ps1"
$LauncherPath = Join-Path -Path $PSScriptRoot -ChildPath "Launcher.ps1"
$Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$LauncherPath`""

# Configurar el icono si existe
if (Test-Path -Path $IconPath) {
    $Shortcut.IconLocation = $IconPath
} else {
    Write-Host "[!] El icono predeterminado no existe: $IconPath" -ForegroundColor Yellow
    Write-Host "[*] Se usará el icono predeterminado de PowerShell." -ForegroundColor Yellow
}

$Shortcut.WorkingDirectory = $PSScriptRoot
$Shortcut.Save()

Write-Host "[+] Acceso directo creado exitosamente en el Escritorio:" -ForegroundColor Green
Write-Host "    $ShortcutPath" -ForegroundColor Green
Write-Host "============================================================"
Start-Sleep -Seconds 3
