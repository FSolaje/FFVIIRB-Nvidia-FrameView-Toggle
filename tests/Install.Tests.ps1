# tests/Install.Tests.ps1
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Join-Path $here "..\src\Install.ps1"
$testDirName = "FFVIIRB-Nvidia-FrameView-Toggle"
$targetDir = Join-Path $env:USERPROFILE "Documents\My Games\FINAL FANTASY VII REBIRTH\$testDirName"
$shortcutName = "FFVII Rebirth (FrameView Toggle)"

Describe "Install.ps1" {
    BeforeAll {
        if (Test-Path $targetDir) { Remove-Item $targetDir -Recurse -Force }
    }
    
    AfterAll {
        if (Test-Path $targetDir) { Remove-Item $targetDir -Recurse -Force }
        $desktop = [Environment]::GetFolderPath('Desktop')
        $lnk = Join-Path $desktop "$shortcutName.lnk"
        if (Test-Path $lnk) { Remove-Item $lnk -Force }
    }

    It "Crea el directorio destino y copia los scripts" {
        # Ejecutamos el instalador
        & $sut
        
        # Validar ruta
        (Test-Path $targetDir) | Should Be $true
        
        (Test-Path (Join-Path $targetDir "Launcher.ps1")) | Should Be $true
        (Test-Path (Join-Path $targetDir "Create-Shortcut.ps1")) | Should Be $true
    }
}
