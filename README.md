# ✦ dotfiles

> A clean, opinionated **Windows** developer environment built around
> [Nushell](https://www.nushell.sh/), [Starship](https://starship.rs/),
> [Conda](https://docs.conda.io/) and [Carapace](https://carapace.sh/).

---

## ✨ Feature Overview

| Component | Purpose |
|-----------|---------|
| **Nushell** (`nu/`) | Shell config & environment variables |
| **Starship** (`starship/`) | Cross-shell prompt with icons & git info |
| **Conda** (`conda/`) | Native Nushell conda environment manager |
| **Carapace** (`carapace/`) | Rich tab-completions for CLI tools |
| **Bootstrap** (`scripts/`) | One-shot PowerShell setup script |

---

## 🗂 Repository Layout

```
dotfiles/
├── nu/
│   ├── config.nu          # Nushell behaviour (VI mode, completions, prompt)
│   └── env.nu             # PATH, EDITOR, STARSHIP_CONFIG, NU_LIB_DIRS
├── starship/
│   └── starship.toml      # Prompt modules: git, python, conda, node, rust…
├── conda/
│   └── nu_conda.nu        # activate / deactivate / find / list commands
├── carapace/
│   └── bridges.yaml       # Bridge conda completions into Carapace
├── scripts/
│   └── bootstrap.ps1      # Symlink everything into the right places
└── README.md
```

---

## 🚀 Quick Start

> See [docs/guide.md](docs/guide.md) for a detailed walkthrough.

### 1. Prerequisites

Install these tools (all available via [Scoop](https://scoop.sh/)):

```powershell
scoop install nushell starship carapace
```

- **Conda / Mamba** – install [Miniforge](https://github.com/conda-forge/miniforge) or Miniconda
- **Nerd Font** – required for icons (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/))

### 2. Clone the repo

```powershell
git clone https://github.com/your-username/dotfiles "$HOME\dotfiles"
```

### 3. Run bootstrap

Open **PowerShell** (or enable Developer Mode to avoid needing admin):

```powershell
& "$HOME\dotfiles\scripts\bootstrap.ps1"
```

The script creates symlinks:

| Symlink | Target |
|---------|--------|
| `%APPDATA%\nushell\config.nu` | `dotfiles\nu\config.nu` |
| `%APPDATA%\nushell\env.nu` | `dotfiles\nu\env.nu` |
| `%APPDATA%\carapace\bridges.yaml` | `dotfiles\carapace\bridges.yaml` |

### 4. Restart your terminal

Open Windows Terminal → Nushell. Your new prompt should appear immediately.

---

## ⚙ Prompt Preview

```
 ~/dev/myproject  main +1 ~2  py:3.11.9  myenv   02:45
❯
```

| Segment | Meaning |
|---------|---------|
| `` | OS icon (Windows/Linux/macOS) |
| `~/dev/myproject` | Current directory (truncated to 3 levels) |
|  `main` | Git branch |
| `+1 ~2` | Git status (staged / modified) |
| ` py:3.11.9` | Python version (when detected) |
| ` myenv` | Active Conda environment |
| `⏱ 3s` | Command duration (right prompt, shown when ≥ 2 s) |
| ` 02:45` | Current time (right prompt) |

---

## 🐍 Conda Commands (Nushell)

```nushell
nu_conda find        # discover all environments from conda/mamba
nu_conda list        # list environments with active flag
nu_conda activate myenv
nu_conda deactivate
```

---

## 🔧 Customisation

| File | Tip |
|------|-----|
| `starship/starship.toml` | Disable any module with `disabled = true` |
| `nu/env.nu` | Add paths to `extra_paths`, change `EDITOR` |
| `nu/config.nu` | Switch to emacs mode: `edit_mode = emacs` |
| `carapace/bridges.yaml` | Add more CLI bridges (e.g. `- name: pip`) |

---

## 📄 License

MIT – do whatever you want.
