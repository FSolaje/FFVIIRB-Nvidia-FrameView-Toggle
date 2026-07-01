# FFVIIRB-Nvidia-FrameView-Toggle

Script en PowerShell que soluciona el conflicto de interfaz (teclado/mando) en Final Fantasy VII Rebirth pausando la telemetría de NVIDIA de forma automatizada.

## Estructura

El proyecto está estructurado de forma modular para adaptarse a diferentes entornos:
- `src/Install.ps1`: Script principal para instalar la herramienta en el equipo.
- `src/Launcher.ps1`: Ejecuta la lógica de lanzar el juego y utiliza el script de toggle para pausar y reanudar el servicio automáticamente.
- `src/Toggle-NvidiaService.ps1`: Alterna de forma independiente el estado del servicio de telemetría de NVIDIA.
- `src/Create-Shortcut.ps1`: Genera un acceso directo en el escritorio para iniciar el launcher cómodamente.
- `src/Uninstaller.ps1`: Script de limpieza para desinstalar la herramienta y eliminar el acceso directo.

## Instalación

1. Ejecuta `src/Install.ps1` (Haz clic derecho en el archivo -> Ejecutar con PowerShell).
2. El script creará una carpeta donde se guardan las partidas: `C:\Users\[TuUsuario]\Documents\My Games\FINAL FANTASY VII REBIRTH\FFVIIRB-Nvidia-FrameView-Toggle`.
3. Allí se copiarán todos los scripts necesarios y se creará automáticamente un acceso directo en tu Escritorio.

## Uso

- Utiliza el acceso directo **FFVII Rebirth (FrameView Toggle)** generado en tu Escritorio.
- El script solicitará privilegios de administrador. Son necesarios para poder pausar el servicio de NVIDIA y evitar el conflicto de interfaz.
- Cuando el juego se cierre, el servicio de NVIDIA volverá a arrancar automáticamente.

## Personalización y Configuración

Dado que el proyecto no usa archivos de configuración externos para maximizar el rendimiento, los parámetros como el ID del juego o el nombre del servicio están definidos como constantes en el inicio de cada script.
Si utilizas otra tienda (Epic Games) o una versión diferente del juego, simplemente abre `src/Launcher.ps1` y `src/Create-Shortcut.ps1` y edita las variables `$AppPathOrURI`, `$ProcessName` o `$IconPath` según tus necesidades antes de ejecutar el instalador.
