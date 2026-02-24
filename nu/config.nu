# config.nu (managed in dotfiles)

$env.config = {
  show_banner: false
  edit_mode: vi
  completions: {
    case_sensitive: false
    quick: true
    partial: true
  }
}

# Starship prompt (if installed)
if (which starship | is-not-empty) {
  $env.PROMPT_COMMAND = {|| starship prompt }
  $env.PROMPT_INDICATOR = ""
  $env.PROMPT_INDICATOR_VI_INSERT = ""
  $env.PROMPT_INDICATOR_VI_NORMAL = ""
}

# Carapace completions (if installed)
# Note: We'll generate the bridge file once during bootstrap to avoid doing it every shell start.
