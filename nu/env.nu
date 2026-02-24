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
  | split row (char esep)
  | prepend $extra_paths
  | uniq
)

# Conda: add condabin to PATH if Miniconda/Anaconda exists in common locations
let conda_candidates = [
  $"($env.USERPROFILE)\\miniconda3\\condabin"
  $"($env.USERPROFILE)\\anaconda3\\condabin"
  "C:\\ProgramData\\miniconda3\\condabin"
  "C:\\ProgramData\\anaconda3\\condabin"
]

for p in $conda_candidates {
  if ($p | path exists) {
    $env.PATH = (
      $env.PATH
      | split row (char esep)
      | prepend [$p]
      | uniq
    )
    break
  }
}
