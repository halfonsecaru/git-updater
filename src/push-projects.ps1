Param(
  [string]$RootPath = (Get-Location).Path,
  [switch]$DryRun
)

# =============================
# Push multiple local projects to their Git remotes
# Usage examples:
#   pwsh .\push-projects.ps1 -RootPath "C:\Users\alfon\Desktop\valid projects"
# Optional: place a repos.json next to this script to auto-add remotes
#   {
#     "almacen-master": "https://github.com/usuario/almacen-master.git",
#     "mcp": "git@github.com:usuario/mcp.git",
#     "milenium-angular": "https://github.com/usuario/milenium-angular.git"
#   }
# =============================

function Ensure-GitInstalled {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or not in PATH. Install it and re-run."
  }
}

function Get-DefaultBranch([string]$repoPath) {
  try {
    $branch = (git -C $repoPath rev-parse --abbrev-ref HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq 'HEAD') { return 'main' }
    return $branch
  } catch { return 'main' }
}

function Has-Remote([string]$repoPath) {
  try {
    $remotes = (git -C $repoPath remote 2>$null)
    return -not [string]::IsNullOrWhiteSpace($remotes)
  } catch { return $false }
}

function Get-Upstream([string]$repoPath) {
  try {
    $u = (git -C $repoPath rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null)
    return $u
  } catch { return $null }
}

function Load-RepoMap {
  $configPath = Join-Path (Split-Path -Parent $PSCommandPath) 'repos.json'
  if (Test-Path $configPath) {
    try { return (Get-Content $configPath -Raw | ConvertFrom-Json) } catch { return @{} }
  }
  return @{}
}

function Get-ConfigPath([string]$fileName) {
  return (Join-Path (Split-Path -Parent $PSCommandPath) $fileName)
}

function Load-Paths {
  $pathFile = Get-ConfigPath 'paths.json'
  if (Test-Path $pathFile) {
    try { return (Get-Content $pathFile -Raw | ConvertFrom-Json) } catch { return @() }
  }
  return @()
}

function Save-Paths([array]$paths) {
  $pathFile = Get-ConfigPath 'paths.json'
  $paths = $paths | Sort-Object -Unique
  ($paths | ConvertTo-Json -Depth 3) | Set-Content -Path $pathFile -Encoding UTF8
}

function Load-CurrentPath {
  $cpFile = Get-ConfigPath 'current-path.json'
  if (Test-Path $cpFile) {
    try { return ((Get-Content $cpFile -Raw | ConvertFrom-Json).currentPath) } catch { return $null }
  }
  return $null
}

function Save-CurrentPath([string]$p) {
  $cpFile = Get-ConfigPath 'current-path.json'
  $obj = @{ currentPath = $p }
  ($obj | ConvertTo-Json -Depth 3) | Set-Content -Path $cpFile -Encoding UTF8
}

function Choose-Item([array]$items, [string]$prompt) {
  if (-not $items -or $items.Count -eq 0) { return $null }
  for ($i = 0; $i -lt $items.Count; $i++) { Write-Host ("[{0}] {1}" -f ($i+1), $items[$i]) }
  $sel = Read-Host $prompt
  if (-not ($sel -match '^\d+$')) { return $null }
  $idx = [int]$sel - 1
  if ($idx -lt 0 -or $idx -ge $items.Count) { return $null }
  return $items[$idx]
}

function Push-Project([string]$path, [string]$name) {
  if (-not (Test-Path (Join-Path $path '.git'))) {
    if ($DryRun) { Write-Host "DRY-RUN: git -C '$path' init" -ForegroundColor Yellow }
    else { git -C $path init | Out-Null }
  }

  if ($DryRun) { Write-Host "DRY-RUN: git -C '$path' add -A" -ForegroundColor Yellow }
  else { git -C $path add -A | Out-Null }

  $msg = "Auto commit $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  if ($DryRun) { Write-Host "DRY-RUN: git -C '$path' commit -m '$msg'" -ForegroundColor Yellow }
  else {
    try { git -C $path commit -m $msg | Out-Null }
    catch { Write-Host "No changes to commit" -ForegroundColor DarkYellow }
  }

  $branch = Get-DefaultBranch $path

  if (-not (Has-Remote $path)) {
    $repoMap = Load-RepoMap
    $remoteUrl = $null
    if ($repoMap -and ($repoMap.PSObject.Properties.Name -contains $name)) { $remoteUrl = $repoMap.$name }

    if ($remoteUrl) {
      if ($DryRun) { Write-Host "DRY-RUN: git -C '$path' remote add origin $remoteUrl" -ForegroundColor Yellow }
      else { git -C $path remote add origin "$remoteUrl" | Out-Null }
    } else {
      Write-Warning "No remote configured for '$name'. Add it: git -C \"$path\" remote add origin <URL>"
      return
    }
  }

  $upstream = Get-Upstream $path
  if (-not $upstream) {
    if ($DryRun) {
      Write-Host "DRY-RUN: git -C '$path' branch -M $branch" -ForegroundColor Yellow
      Write-Host "DRY-RUN: git -C '$path' push -u origin $branch" -ForegroundColor Yellow
    } else {
      git -C $path branch -M $branch | Out-Null
      git -C $path push -u origin $branch
    }
  } else {
    if ($DryRun) { Write-Host "DRY-RUN: git -C '$path' push" -ForegroundColor Yellow }
    else { git -C $path push }
  }
}

function Push-AllProjects([string]$rootPath) {
  if (-not (Test-Path $rootPath)) { throw "Specified path does not exist: $rootPath" }
  $projects = Get-ChildItem -Path $rootPath -Directory
  if ($projects.Count -eq 0) { Write-Warning "No project subfolders found in: $rootPath"; return }
  Write-Host "Processing $($projects.Count) projects in '$rootPath'" -ForegroundColor Cyan
  foreach ($p in $projects) {
    Write-Host "\n=> Project: $($p.Name)" -ForegroundColor Green
    Push-Project -path $p.FullName -name $p.Name
  }
}

function Show-Menu {
  while ($true) {
    $paths = Load-Paths
    $current = Load-CurrentPath
    if ($current) { Write-Host "Current path: $current" -ForegroundColor Cyan }
    Write-Host "\nMenu:" -ForegroundColor Cyan
    Write-Host "[1] Add new path for Git projects"
    Write-Host "[2] Remove saved paths"
    Write-Host "[3] Push existing projects"
    Write-Host "[4] Exit"
    $opt = Read-Host "Select an option"

    switch ($opt) {
      '1' {
        $newPath = Read-Host "Enter the absolute folder path containing projects"
        if (-not (Test-Path $newPath)) { Write-Warning "Path does not exist" }
        else {
          $paths += $newPath
          Save-Paths $paths
          Save-CurrentPath $newPath
          Write-Host "Path added and set as current." -ForegroundColor Green
        }
      }
      '2' {
        if (-not $paths -or $paths.Count -eq 0) { Write-Warning "No saved paths" }
        else {
          $sel = Choose-Item -items $paths -prompt "Choose a number to remove"
          if ($sel) {
            $paths = $paths | Where-Object { $_ -ne $sel }
            Save-Paths $paths
            if ($current -eq $sel) { Save-CurrentPath ($paths | Select-Object -First 1) }
            Write-Host "Path removed." -ForegroundColor Green
          }
        }
      }
      '3' {
        if (-not $paths -or $paths.Count -eq 0) {
          $tmp = Read-Host "No saved paths. Enter a path now"
          if (-not (Test-Path $tmp)) { Write-Warning "Path does not exist" }
          else { $paths += $tmp; Save-Paths $paths; Save-CurrentPath $tmp }
        }
        $chosen = Choose-Item -items $paths -prompt "Choose the path to push"
        if ($chosen) {
          Save-CurrentPath $chosen
          Write-Host "[1] Push all projects"; Write-Host "[2] Push a single project"
          $mode = Read-Host "Select"
          switch ($mode) {
            '1' { Push-AllProjects -rootPath $chosen }
            '2' {
              $projects = (Get-ChildItem -Path $chosen -Directory).Name
              if (-not $projects -or $projects.Count -eq 0) { Write-Warning "No projects found" }
              else {
                $one = Choose-Item -items $projects -prompt "Choose a project"
                if ($one) { Push-Project -path (Join-Path $chosen $one) -name $one }
              }
            }
            default { Write-Warning "Invalid option" }
          }
        } else {
          Write-Warning "Invalid selection"
        }
      }
      '4' { return }
      default { Write-Warning "Invalid option" }
    }
  }
}

Ensure-GitInstalled

if ($PSBoundParameters.ContainsKey('RootPath')) {
  Push-AllProjects -rootPath $RootPath
} else {
  Show-Menu
}