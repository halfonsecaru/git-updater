// ******************* English ******************* //

Description
- Script `push-projects.ps1` (located in `src/`) to push local projects to their Git remotes, with an interactive menu and JSON-based configuration.

Requirements
- `git` installed and available in `PATH`.
- PowerShell (Windows PowerShell or `pwsh` 7).

Config files (alongside the script)
- `paths.json`: list of folder paths that contain projects.
  - Example: `["C:\\Users\\alfon\\Desktop\\valid proyects"]`
- `current-path.json`: currently selected path.
  - Format: `{ "currentPath": "C:\\Users\\alfon\\Desktop\\valid proyects" }`
- `repos.json`: map `folderName -> origin remote URL`.
  - Example:
    {
      "almacen-master": "https://github.com/usuario/almacen-master.git",
      "mcp": "git@github.com:usuario/mcp.git",
      "milenium-angular": "https://github.com/usuario/milenium-angular.git"
    }

Quick start (interactive menu)
- From the repository root, run:
  `start.bat`
- Menu flow:
  - `[1]` Add new path for Git projects: add a folder like `C:\\Users\\usuario\\Desktop\\valid proyects`.
  - `[2]` Remove saved paths: delete a stored path.
  - `[3]` Push existing: choose the path, then the mode:
    - Push all projects in that path.
    - Push a single project: you’ll see the folders list; choose one to push only that project.
  - `[4]` Exit.

Direct execution (no menu)
- Push all projects in a specific path:
  `start.bat -RootPath "C:\\Users\\alfon\\Desktop\\valid proyects"`
- Dry-run (no changes made):
  `start.bat -DryRun`

Direct execution of the script (no menu)
- Push all projects in a specific path:
  `pwsh .\\push-projects.ps1 -RootPath "C:\\Users\\alfon\\Desktop\\valid proyects"`
- Dry-run (no changes made):
  `pwsh .\\push-projects.ps1 -DryRun`

Automatic commit message
- Always: `Auto commit YYYY-MM-DD HH:mm:ss` (current date and time).

What the script does
- Iterates over subfolders in the selected path.
- Initializes `git` if missing, runs `add -A` and `commit` when there are changes.
- Uses or creates the default branch (detects current; if none, `main`).
- Configures `origin` from `repos.json` (located next to the script in `src/`) if missing and pushes to the remote.

Notes
- If your repos use `master` instead of `main`, the existing branch is respected.
- If you see "No remote configured", add it manually:
  `git -C "PROJECT_PATH" remote add origin <URL>`
- Ask us to change the commit date format if you prefer a different one.

// ******************* Spanish ******************* //

Descripción
- Script `push-projects.ps1` (ubicado en `src/`) para subir proyectos locales a sus repos remotos con menú interactivo y configuración en JSON.

Requisitos
- Tener `git` instalado y en `PATH`.
- PowerShell (Windows PowerShell o `pwsh` 7).

Archivos de configuración (junto al script)
- `paths.json`: lista de rutas de carpetas que contienen proyectos.
  - Ejemplo: `["C:\\Users\\alfon\\Desktop\\valid proyects"]`
- `current-path.json`: ruta actual seleccionada.
  - Formato: `{ "currentPath": "C:\\Users\\alfon\\Desktop\\valid proyects" }`
- `repos.json`: mapa `nombreDeCarpeta -> URL del remoto origin`.
  - Ejemplo:
    {
      "almacen-master": "https://github.com/usuario/almacen-master.git",
      "mcp": "git@github.com:usuario/mcp.git",
      "milenium-angular": "https://github.com/usuario/milenium-angular.git"
    }

Uso rápido (menú interactivo)
- Desde la carpeta raíz, ejecuta:
  `start.bat`
- Flujo del menú:
  - `[1]` Ingresar nueva ruta para proyectos Git: añade una carpeta como `C:\\Users\\usuario\\Desktop\\valid proyects`.
  - `[2]` Eliminar rutas para proyectos Git: borra una ruta guardada.
  - `[3]` Subir existentes: elige la ruta, luego el modo:
    - Subir todos los proyectos de esa ruta.
    - Subir un proyecto: verás la lista de carpetas; selecciona una y se sube solo esa.
  - `[4]` Salir.

Ejecución directa (sin menú)
- Empujar todos los proyectos de una ruta concreta:
  `start.bat -RootPath "C:\\Users\\alfon\\Desktop\\valid proyects"`
- Modo prueba sin cambios:
  `start.bat -DryRun`

Ejecución directa (sin menú)
- Empujar todos los proyectos de una ruta concreta:
  `pwsh .\\push-projects.ps1 -RootPath "C:\\Users\\alfon\\Desktop\\valid proyects"`
- Modo prueba sin cambios:
  `pwsh .\\push-projects.ps1 -DryRun`

Mensaje de commit automático
- Siempre: `Auto commit YYYY-MM-DD HH:mm:ss` (fecha y hora actuales).

Qué hace el script
- Recorre subcarpetas de la ruta elegida.
- Inicializa `git` si falta, hace `add -A` y `commit` si hay cambios.
- Usa o crea la rama por defecto (detecta la actual; si no, `main`).
- Configura `origin` desde `repos.json` (ubicado junto al script en `src/`) si falta y empuja al remoto.

Notas
- Si tus repos usan `master` en lugar de `main`, se respeta la rama existente.
- Si aparece "No hay remoto configurado", añade manualmente:
  `git -C "RUTA_DEL_PROYECTO" remote add origin <URL>`
- Para ajustar el formato de fecha del commit, pide el formato deseado.