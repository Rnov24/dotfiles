# 📖 Setup Guide

Step-by-step tutorial for getting this dotfiles environment running on a fresh Windows machine.

---

## Table of Contents

1. [Install Prerequisites](#1-install-prerequisites)
2. [Configure Windows Terminal](#2-configure-windows-terminal)
3. [Clone & Bootstrap](#3-clone--bootstrap)
4. [Verify the Prompt](#4-verify-the-prompt)
5. [Conda Environments](#5-conda-environments)
6. [Carapace Completions](#6-carapace-completions)
7. [Customising the Prompt](#7-customising-the-prompt)
8. [Updating Dotfiles](#8-updating-dotfiles)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Install Prerequisites

### Option A — Scoop (recommended)

```powershell
# Install Scoop if you don't have it
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install core tools
scoop install git nushell starship carapace
```

### Option B — Manual

| Tool | Download |
|------|----------|
| Nushell | https://github.com/nushell/nushell/releases |
| Starship | https://starship.rs/guide/#step-1-install-starship |
| Carapace | https://carapace-sh.github.io/carapace-bin/installation.html |
| Git | https://git-scm.com/download/win |

### Conda / Mamba

Install [Miniforge](https://conda-forge.org/download/) (recommended) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html).  
During installation, **do not** add Conda to PATH automatically — this repo handles PATH via `nu_conda.nu`.

### Nerd Font

The Starship prompt uses [Nerd Font](https://www.nerdfonts.com/) icons.  
Recommended: **JetBrainsMono Nerd Font** or **CaskaydiaCove Nerd Font**.

```powershell
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

---

## 2. Configure Windows Terminal

1. Open **Windows Terminal** → Settings → **Add a new profile**
2. Set **Command line** to the path of `nu.exe`, e.g.:  
   `C:\Users\<you>\scoop\shims\nu.exe`
3. Under **Appearance**, set the font to your installed Nerd Font (e.g. **JetBrainsMono Nerd Font**)
4. Optionally set this profile as the default

---

## 3. Clone & Bootstrap

```powershell
# 1. Clone the repo
git clone https://github.com/your-username/dotfiles "$HOME\dotfiles"

# 2. Run bootstrap (creates symlinks)
& "$HOME\dotfiles\scripts\bootstrap.ps1"
```

> **Note:** If you get a symlink permission error, either:
> - Enable **Developer Mode** in Windows Settings → Privacy & Security → For Developers, **or**
> - Run PowerShell as **Administrator**

### What bootstrap.ps1 does

```
dotfiles\nu\config.nu    ──►  %APPDATA%\nushell\config.nu
dotfiles\nu\env.nu       ──►  %APPDATA%\nushell\env.nu
dotfiles\carapace\*.yaml ──►  %APPDATA%\carapace\bridges.yaml
```

It also runs `carapace _carapace nushell` to generate `carapace-completions.nu` if Carapace is installed.

---

## 4. Verify the Prompt

Open a **new** Nushell session in Windows Terminal. You should see a prompt like:

```
 ~/dotfiles  main  02:45
❯
```

If the prompt shows `starship: error` or boxes instead of icons, check:
- ✅ Starship is on your PATH (`which starship`)
- ✅ You are using a Nerd Font in your terminal
- ✅ `$env.STARSHIP_CONFIG` points to `dotfiles\starship\starship.toml`

---

## 5. Conda Environments

`nu_conda.nu` provides native Nushell commands for Conda — no shell hook needed.

```nushell
# Discover all environments once (reads from conda/mamba)
nu_conda find

# List environments
nu_conda list
# ╭───┬─────────────┬────────┬───────────────────────────────────╮
# │ # │ name        │ active │ path                              │
# ├───┼─────────────┼────────┼───────────────────────────────────┤
# │ 0 │ base        │ false  │ C:\Users\you\miniforge3           │
# │ 1 │ ml          │ false  │ C:\Users\you\miniforge3\envs\ml   │
# ╰───┴─────────────┴────────┴───────────────────────────────────╯

# Activate an environment
nu_conda activate ml

# Deactivate
nu_conda deactivate
```

> The active environment is shown in the Starship prompt automatically  
> via the `[conda]` module (reads `$env.CONDA_DEFAULT_ENV`).

---

## 6. Carapace Completions

Carapace provides tab-completions for hundreds of CLIs.

After bootstrap, completions are sourced automatically from  
`%APPDATA%\nushell\carapace-completions.nu`.

**Regenerate completions** (e.g. after upgrading Carapace):

```powershell
carapace _carapace nushell | save -f "$env:APPDATA\nushell\carapace-completions.nu"
```

**Conda bridge** is already enabled in `carapace/bridges.yaml`:

```yaml
- name: conda
```

Add more bridges by appending entries, e.g.:

```yaml
- name: pip
- name: docker
```

---

## 7. Customising the Prompt

The prompt is configured in `starship/starship.toml`.  
Changes take effect immediately in new shell sessions (no restart required since `STARSHIP_CONFIG` points directly to the repo file).

### Disable a module

```toml
[nodejs]
disabled = true
```

### Change the prompt symbol

```toml
[character]
success_symbol = "[→](bold green)"
error_symbol   = "[→](bold red)"
```

### Change directory truncation

```toml
[directory]
truncation_length = 5   # show more path segments
truncate_to_repo  = false
```

### Add `direnv` support

```toml
[direnv]
disabled = false
```

---

## 8. Updating Dotfiles

Because bootstrap uses **symlinks**, edits to files in `~/dotfiles` take effect immediately.

```nushell
# Pull latest changes
cd ~/dotfiles
git pull

# Re-run bootstrap only if new files were added
& "~/dotfiles/scripts/bootstrap.ps1"
```

---

## 9. Troubleshooting

| Problem | Fix |
|---------|-----|
| Boxes `▯` instead of icons | Install a Nerd Font and set it in your terminal |
| `nu_conda: command not found` | Check `$env.NU_LIB_DIRS` includes `dotfiles\conda` |
| `carapace-completions.nu failed to load` | Run `carapace _carapace nushell \| save -f ...` to regenerate |
| Symlink creation failed | Enable Developer Mode or run as Administrator |
| Starship not found | Add Starship's install directory to your PATH in `env.nu` |
| `std-rfc/kv not found` | Install it: `nupm install std-rfc` (requires [nupm](https://github.com/nushell/nupm)) |
