# tests/Launcher.Tests.ps1
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = Join-Path $here "..\src\Launcher.ps1"
Describe "Launcher.ps1" {

    Context "Cuando el servicio está corriendo" {
        It "Ejecuta la secuencia correcta (Stop -> Start-Process -> Wait -> Start-Service)" {
            # Mocks de sistema para no arrancar nada real
            $global:serviceState = 'Running'
            Mock Get-Service { return [PSCustomObject]@{ Status = $global:serviceState; Name = 'FvSvc' } }
            Mock Stop-Service { $global:serviceState = 'Stopped' }
            Mock Start-Process {}
            Mock Get-Process { return $true }
            Mock Wait-Process {}
            Mock Start-Service { $global:serviceState = 'Running' }
            Mock Start-Sleep {}

            # Ejecutamos el SUT
            # Al ejecutarse invoca Start-Process y demás.
            & $sut -SkipAdminCheck

            # Assertions
            Assert-MockCalled Stop-Service -Times 1 -Exactly
            Assert-MockCalled Start-Process -Times 1 -Exactly
            Assert-MockCalled Wait-Process -Times 1 -Exactly
            Assert-MockCalled Start-Service -Times 1 -Exactly
        }
    }

    Context "Cuando el servicio está detenido" {
        It "Solo arranca el proceso sin tocar los servicios" {
            # Mocks
            $global:serviceState = 'Stopped'
            Mock Get-Service { return [PSCustomObject]@{ Status = $global:serviceState; Name = 'FvSvc' } }
            Mock Stop-Service {}
            Mock Start-Process {}
            Mock Wait-Process {}
            Mock Start-Service {}
            Mock Start-Sleep {}

            # Ejecutamos el SUT
            & $sut -SkipAdminCheck

            # Assertions
            Assert-MockCalled Stop-Service -Times 0 -Exactly
            Assert-MockCalled Start-Process -Times 1 -Exactly
            Assert-MockCalled Wait-Process -Times 0 -Exactly
            Assert-MockCalled Start-Service -Times 0 -Exactly
        }
    }
}
