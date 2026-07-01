# tests/Create-Shortcut.Tests.ps1
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Join-Path $here "..\src\Create-Shortcut.ps1"
$testShortcut = "FFVII Rebirth (FrameView Toggle)"
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath "$testShortcut.lnk"

Describe "Create-Shortcut.ps1" {
    BeforeAll {
        if (Test-Path $shortcutPath) { Remove-Item $shortcutPath -Force }
    }
    
    AfterAll {
        if (Test-Path $shortcutPath) { Remove-Item $shortcutPath -Force }
    }

    It "Crea exitosamente el acceso directo en el Escritorio" {
        # Create-Shortcut.ps1 genera el acceso directo basado en constantes internas
        
        & $sut
        (Test-Path $shortcutPath) | Should Be $true
    }

    It "Contiene las propiedades correctas en el acceso directo" {
        $WshShell = New-Object -ComObject WScript.Shell
        $lnk = $WshShell.CreateShortcut($shortcutPath)
        
        $lnk.TargetPath | Should Match "powershell.exe"
        $lnk.Arguments | Should Match "-WindowStyle Hidden"
        $lnk.Arguments | Should Match "-ExecutionPolicy Bypass"
        $lnk.Arguments | Should Match "Launcher.ps1"
    }
}
