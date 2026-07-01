[CmdletBinding()]
param (
    [string]$TargetDirName = "FFVIIRB-Nvidia-FrameView-Toggle",
    [string]$ShortcutName = "FFVII Rebirth (FrameView Toggle)",
    [string]$InstallDirName = "Documents\My Games\FINAL FANTASY VII REBIRTH",
    [switch]$Help
)

# ============================================================
# Soporte para caracteres especiales (UTF-8)
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if ($Help) {
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  Ayuda: Instalador de FFVIIRB Nvidia FrameView Toggle" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Uso: .\Install.ps1 [Parámetros]"
    Write-Host ""
    Write-Host "Parámetros opcionales:"
    Write-Host "  -InstallDirName <string>   Ruta relativa al perfil de usuario para instalar (por defecto: Documents\My Games\FINAL FANTASY VII REBIRTH)"
    Write-Host "  -TargetDirName <string>    Nombre de la carpeta de destino (por defecto: FFVIIRB-Nvidia-FrameView-Toggle)"
    Write-Host "  -ShortcutName <string>     Nombre del acceso directo (por defecto: FFVII Rebirth (FrameView Toggle))"
    Write-Host "  -Help                      Muestra esta ayuda"
    Write-Host "============================================================" -ForegroundColor Cyan
    exit
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Instalador - FFVIIRB Nvidia FrameView Toggle" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Definir la ruta destino dentro de la carpeta del usuario
$TargetDir = Join-Path -Path $env:USERPROFILE -ChildPath "$InstallDirName\$TargetDirName"

# Crear directorio si no existe
if (-not (Test-Path -Path $TargetDir)) {
    Write-Host "[*] Creando directorio de instalación en:`n    $TargetDir"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
else {
    Write-Host "[*] El directorio de instalación ya existe en:`n    $TargetDir"
}

$SourceDir = $PSScriptRoot

# Comprobar si los archivos origen existen
$LauncherSource = Join-Path -Path $SourceDir -ChildPath "Launcher.ps1"
$ShortcutCreatorSource = Join-Path -Path $SourceDir -ChildPath "Create-Shortcut.ps1"
$ToggleSource = Join-Path -Path $SourceDir -ChildPath "Toggle-NvidiaService.ps1"
$UninstallerSource = Join-Path -Path $SourceDir -ChildPath "Uninstaller.ps1"

if (-not (Test-Path -Path $LauncherSource) -or -not (Test-Path -Path $ShortcutCreatorSource) -or -not (Test-Path -Path $ToggleSource) -or -not (Test-Path -Path $UninstallerSource)) {
    Write-Host "[!] Error: No se encuentran todos los scripts origen en $SourceDir." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

# Copiar scripts
Write-Host "[*] Copiando scripts al directorio destino..."
Copy-Item -Path $LauncherSource -Destination $TargetDir -Force
Copy-Item -Path $ShortcutCreatorSource -Destination $TargetDir -Force
Copy-Item -Path $ToggleSource -Destination $TargetDir -Force
Copy-Item -Path $UninstallerSource -Destination $TargetDir -Force



# Ejecutar el generador de accesos directos
Write-Host "[*] Creando acceso directo en el escritorio..."
$TargetShortcutCreator = Join-Path -Path $TargetDir -ChildPath "Create-Shortcut.ps1"
& $TargetShortcutCreator -ShortcutName $ShortcutName | Out-Null

Write-Host "[+] Instalación completada con éxito." -ForegroundColor Green
Write-Host "[*] Puedes iniciar el juego desde el acceso directo 'FFVII Rebirth (FrameView Toggle)' en tu Escritorio." -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Saliendo en 5 segundos..."
Start-Sleep -Seconds 5
