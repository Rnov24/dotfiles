# env.nu (managed in dotfiles)

# Point Starship to the version tracked in this repo
$env.STARSHIP_CONFIG = $"($env.USERPROFILE)\\dotfiles\\starship\\starship.toml"

# Preferred editor
$env.EDITOR = "code"
$env.VISUAL = "code"

# Extra PATH entries (keep minimal and deterministic)
let extra_paths = [
  $"($env.USERPROFILE)\\AppData\\Local\\Microsoft\\WindowsApps"
  $"($env.USERPROFILE)\\scoop\\shims"
  $"($env.USERPROFILE)\\.cargo\\bin"
]

$env.PATH = (
  $env.PATH
  | prepend $extra_paths
  | uniq
)

# Module search paths — lets config.nu use modules by name (e.g. `use nu_conda.nu *`)
$env.NU_LIB_DIRS = (
  $env.NU_LIB_DIRS? | default []
  | append ($env.USERPROFILE | path join "dotfiles" "conda")
)
