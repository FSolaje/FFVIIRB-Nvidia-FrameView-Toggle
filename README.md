# FFVIIRB-Nvidia-FrameView-Toggle

Script en PowerShell que soluciona el conflicto de interfaz (teclado/mando) en Final Fantasy VII Rebirth pausando la telemetría de NVIDIA de forma automatizada.

## Estructura

El proyecto está estructurado de forma modular para adaptarse a diferentes entornos:
- `src/Install.ps1`: Script principal para instalar la herramienta en el equipo.
- `src/Launcher.ps1`: Ejecuta la lógica de lanzar el juego y utiliza el script de toggle para pausar y reanudar el servicio automáticamente.
- `src/Toggle-NvidiaService.ps1`: Alterna de forma independiente el estado del servicio de telemetría de NVIDIA.
- `src/Create-Shortcut.ps1`: Genera un acceso directo en el escritorio para iniciar el launcher cómodamente.
- `src/Uninstaller.ps1`: Script de limpieza para desinstalar la herramienta y eliminar el acceso directo.

## Modos de Uso

La herramienta puede utilizarse de dos formas: **Modo Automático (Instalación)** y **Modo Manual**.

### 1. Modo Automático (Recomendado)
Ideal si quieres que el proceso sea completamente transparente y automático cada vez que vayas a jugar.

**Instalación:**
1. Ejecuta `src/Install.ps1` (haz clic derecho en el archivo -> Ejecutar con PowerShell).
   - *Alternativa:* Si Windows te muestra un error indicando que la ejecución de scripts está deshabilitada, abre una consola y ejecuta:
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File .\Install.ps1
     ```
2. Se creará una carpeta en la ruta de guardado del juego: `C:\Users\[TuUsuario]\Documents\My Games\FINAL FANTASY VII REBIRTH\FFVIIRB-Nvidia-FrameView-Toggle`.
3. Allí se copiarán los scripts necesarios y se generará automáticamente un acceso directo en tu Escritorio llamado **FFVII Rebirth (FrameView Toggle)**.

**Ejecución:**
- Haz doble clic en el acceso directo generado en el Escritorio.
- **Privilegios de Administrador:** Se solicitará permiso de administrador mediante una ventana emergente de Windows (UAC). Debes aceptar para que el script tenga permisos para pausar el servicio de NVIDIA.
- **Ventana de PowerShell:** Gracias a los parámetros del acceso directo, la ventana de comandos se ejecutará de forma **totalmente oculta** (en segundo plano), por lo que no verás ninguna consola abierta.
- **Proceso:** El script detendrá el servicio conflictivo, abrirá el juego automáticamente y se quedará esperando en segundo plano. Una vez cierres el juego, restaurará el servicio de NVIDIA y finalizará sin ninguna intervención adicional.

### 2. Modo Manual (Modo "Toggle")
Ideal si solo quieres detener el servicio de telemetría de forma independiente sin utilizar el Launcher para abrir el juego (por ejemplo, si prefieres lanzar el juego desde Steam/Epic manualmente).

**Ejecución:**
- Descarga únicamente el archivo `src/Toggle-NvidiaService.ps1` y guárdalo en cualquier lugar de tu equipo.
- Haz clic derecho sobre el archivo descargado y selecciona **Ejecutar con PowerShell**.
  - *Alternativa:* Si Windows te muestra un error indicando que la ejecución de scripts está deshabilitada, abre una consola y ejecuta:
    ```powershell
    powershell.exe -ExecutionPolicy Bypass -File .\Toggle-NvidiaService.ps1
    ```
- **Privilegios de Administrador:** Al igual que en el modo automático, el script requiere permisos de administrador. Si no lo ejecutas como administrador desde el principio, el script cuenta con un sistema de autoelevación: se reiniciará automáticamente solicitándote permisos (UAC).
- **Ventana de PowerShell:** En este modo, la ventana de consola **sí será visible**. 
- **Proceso:** El script actuará como un interruptor. Leerá el estado actual del servicio `FvSvc`:
  - Si está activo, mostrará un texto indicando que lo está **deteniendo**.
  - Si ya estaba detenido, indicará que lo está **reanudando**.
- **Finalización:** Tras mostrar el resultado en pantalla, aparecerá el mensaje `"Cerrando en 3 segundos..."`. La ventana se cerrará sola tras esta breve pausa para que tengas tiempo de leer el estado final. 
- *Importante:* Si usas este modo, tendrás que abrir el juego manualmente. Recuerda volver a ejecutar el script cuando termines de jugar para restaurar el servicio de telemetría a su estado original.

## Personalización y Configuración

Dado que el proyecto no usa archivos de configuración externos para maximizar el rendimiento, los parámetros como el ID del juego o el nombre del servicio están definidos como constantes en el inicio de cada script.
Si utilizas otra tienda (Epic Games) o una versión diferente del juego, simplemente abre `src/Launcher.ps1` y `src/Create-Shortcut.ps1` y edita las variables `$AppPathOrURI`, `$ProcessName` o `$IconPath` según tus necesidades antes de ejecutar el instalador.

### Parámetros de los Scripts

Los diferentes scripts del proyecto aceptan parámetros por línea de comandos para modificar su comportamiento o facilitar su automatización. Todos incluyen un parámetro `-Help` para consultar la ayuda directamente desde la consola.

#### 1. Install.ps1
- `-InstallDirName <string>`: Permite modificar la ruta base de instalación relativa a la carpeta del usuario.
- `-TargetDirName <string>`: Permite cambiar el nombre de la carpeta destino.
- `-ShortcutName <string>`: Permite cambiar el nombre del acceso directo generado.

**Ejemplo de uso:**
```powershell
.\Install.ps1 -InstallDirName "Desktop" -TargetDirName "FF7RB-Tools"
```

#### 2. Launcher.ps1
- `-SkipAdminCheck`: Omite la comprobación inicial de privilegios y el intento de autoelevación (UAC). Útil si ya estás ejecutando el script desde una consola con permisos de administrador.

**Ejemplo de uso:**
```powershell
.\Launcher.ps1 -SkipAdminCheck
```

#### 3. Toggle-NvidiaService.ps1
- `-SkipAdminCheck`: Omite la comprobación inicial de privilegios.
- `-NoWait`: Ejecuta el script sin la pausa final de 3 segundos, cerrando inmediatamente al terminar. Ideal para llamadas automatizadas.

**Ejemplo de uso:**
```powershell
.\Toggle-NvidiaService.ps1 -SkipAdminCheck -NoWait
```
