brew "bat"
brew "bats-core" # Bash test framework, used by core/ai/claude-box
brew "beads" # Task manager for AI agents
brew "bottom"
brew "chafa"
brew "coreutils"
brew "countdown"
brew "curl"
brew "direnv"
brew "eza"
brew "fd"
brew "fnm"
brew "fzf"
brew "gcc"
brew "gh"
brew "git"
brew "git-delta"
brew "gitleaks"
brew "glow"
brew "go"
brew "gron"
brew "gum"
brew "herdr"
brew "htop"
brew "jless"
brew "mdserve"
brew "ncdu"
brew "neovim"
brew "poppler"
brew "python"
brew "ripgrep"
brew "rtk" # High-performance CLI proxy that reduces LLM token consumption
brew "tabiew"
brew "tig"
brew "tmux"
brew "toilet"
brew "tree-sitter"
brew "tree-sitter-cli"
brew "uv"
brew "wget"
brew "yazi"

uv "git-fame"
uv "neovim-remote"

if OS.mac?
  cask_args appdir: '~/Applications' # avoid requiring sudo

  brew "bash"
  brew "findutils"
  brew "fish"
  brew "gnu-sed"
  brew "grep"
  brew "terminal-notifier"

  cask "kitty"
  cask "hammerspoon"

  cask "font-agave"
  cask "font-monaspace"
  cask "font-comic-mono"
  cask "font-liga-comic-mono"

  if !File.exist?(File.expand_path("~/.config/dotfiles/skip-gui-apps"))
    cask "chatgpt"
    cask "freecad"
    cask "keepassxc"
    cask "obsidian"
    cask "openscad@snapshot"
    cask "prusaslicer"
    cask "spotify"
    cask "telegram"
  end
end
