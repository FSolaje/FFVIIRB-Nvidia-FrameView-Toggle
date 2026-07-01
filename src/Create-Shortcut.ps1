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

# Cargar Configuración Dinámica para obtener el icono
$ConfiguratorPath = Join-Path -Path $PSScriptRoot -ChildPath "Configurator.ps1"
if (-not (Test-Path -Path $ConfiguratorPath)) {
    Write-Host "[!] Error: No se encuentra Configurator.ps1 en $PSScriptRoot" -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

$Config = & $ConfiguratorPath

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

# Configurar el icono si está definido y existe, o usar el de Steam por defecto del config
if ($null -ne $Config.IconPath) {
    if (Test-Path -Path $Config.IconPath) {
        $Shortcut.IconLocation = $Config.IconPath
    }
    else {
        Write-Host "[!] El icono especificado en config.json no existe: $($Config.IconPath)" -ForegroundColor Yellow
        Write-Host "[*] Se usará el icono predeterminado de PowerShell." -ForegroundColor Yellow
    }
}

$Shortcut.WorkingDirectory = $PSScriptRoot
$Shortcut.Save()

Write-Host "[+] Acceso directo creado exitosamente en el Escritorio:" -ForegroundColor Green
Write-Host "    $ShortcutPath" -ForegroundColor Green
Write-Host "============================================================"
Start-Sleep -Seconds 3
