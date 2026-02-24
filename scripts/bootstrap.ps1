$ErrorActionPreference = "Stop"

$Dotfiles = Join-Path $HOME "dotfiles"
$NuDir = Join-Path $env:APPDATA "nushell"

New-Item -ItemType Directory -Force -Path $NuDir | Out-Null

function Link-File {
  param(
    [Parameter(Mandatory=$true)][string]$Target,
    [Parameter(Mandatory=$true)][string]$Link
  )

  if (Test-Path $Link) {
    Remove-Item $Link -Force
  }

  try {
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
    Write-Host "Linked: $Link -> $Target"
  } catch {
    Write-Host "FAILED to create symlink for $Link"
    Write-Host "Reason: $($_.Exception.Message)"
    Write-Host ""
    Write-Host "Fix options:"
    Write-Host "1) Enable Developer Mode in Windows (recommended), then rerun."
    Write-Host "2) Or run PowerShell as Administrator, then rerun."
    throw
  }
}

# ── Nushell configs ────────────────────────────────────────────────────────────
Link-File (Join-Path $Dotfiles "nu\config.nu") (Join-Path $NuDir "config.nu")
Link-File (Join-Path $Dotfiles "nu\env.nu")    (Join-Path $NuDir "env.nu")

# ── Carapace config files ──────────────────────────────────────────────────────
$CarapaceConfigDir = Join-Path $env:APPDATA "carapace"
New-Item -ItemType Directory -Force -Path $CarapaceConfigDir | Out-Null

$DotfilesCarapace = Join-Path $Dotfiles "carapace"
Get-ChildItem $DotfilesCarapace -File | ForEach-Object {
  Link-File $_.FullName (Join-Path $CarapaceConfigDir $_.Name)
}

# ── Carapace nushell completions init ─────────────────────────────────────────
$CarapaceNu = Join-Path $NuDir "carapace-completions.nu"
$Carapace = Get-Command carapace -ErrorAction SilentlyContinue

if ($null -ne $Carapace) {
  Write-Host "Generating carapace-completions.nu..."
  $script = (& carapace _carapace nushell) -join "`n"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($CarapaceNu, $script, $utf8NoBom)
  Write-Host "Generated: $CarapaceNu"
} else {
  Write-Host "carapace not found. Skipping carapace-completions.nu generation."
}

Write-Host ""
Write-Host "Bootstrap done. Restart Windows Terminal / Nushell."
