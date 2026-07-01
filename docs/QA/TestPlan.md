# Plan de Aseguramiento de Calidad (QA) - Tests

Este documento describe la estrategia de testing del proyecto `FFVIIRB-Nvidia-FrameView-Toggle`, haciendo uso del framework **Pester**.

## 1. Alcance de las Pruebas
Todos los scripts del repositorio ubicados en `src/` están cubiertos por pruebas unitarias o de integración:
- `Create-Shortcut.ps1`
- `Install.ps1`
- `Launcher.ps1`

## 2. Prevención de Polución
Para garantizar que las pruebas no alteren permanentemente el entorno del usuario, las pruebas unitarias emplean bloques `BeforeAll` y `AfterAll` para limpiar el entorno y garantizar que regrese a su estado original tras los tests.
Adicionalmente, se incluye el script `src/Uninstaller.ps1` que el usuario puede ejecutar para eliminar todos los rastros de la instalación.

## 3. Estrategia de Mocks
Para los scripts que interactúan de manera destructiva o profunda con el sistema (como `Launcher.ps1` que detiene servicios de Windows y arranca ejecutables), se emplean **Mocks**.
Pester intercepta llamadas a cmdlets como `Get-Service`, `Stop-Service`, y `Start-Process` para validar su lógica sin ejecutarlos en el sistema operativo subyacente.
