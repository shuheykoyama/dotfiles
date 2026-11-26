# shuhey's dotfiles

## I still love Neovim

Even after entering the era of agentic coding, I still love Neovim.
Nowadays, I use it almost exclusively as a code review tool.
I have stripped away features that became unnecessary now that I no longer write code by hand, keeping my configuration small, lightweight, and simple.

## Contents

- Neovim config
- herdr config
- Ghostty config
- git and lazygit config
- fish config
- Homebrew package lists

## Neovim setup

### Requirements

- Neovim >= **0.12** (plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim))
- Git
- [lazygit](https://github.com/jesseduffield/lazygit): simple terminal UI for git commands
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) and a **C** compiler for `nvim-treesitter`
- for the [snacks.nvim](https://github.com/folke/snacks.nvim) picker:
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that supports true color and _undercurl_, such as [Ghostty](https://ghostty.org/)
- [Solarized Osaka](https://github.com/craftzdog/solarized-osaka.nvim)
  - I also prefer [Kanagawa Dragon](https://github.com/rebelot/kanagawa.nvim)

## Terminal setup

- [Ghostty](https://ghostty.org/) - Terminal emulator I love
- [herdr](https://herdr.dev/) - Workspace manager for running AI coding agents side by side, with tmux-style keybindings (prefix `ctrl+t`)

### Fonts

Installed as Homebrew casks from the `Brewfile`:

- [PlemolJP](https://github.com/yuru7/PlemolJP) (`PlemolJP Console NF`) - A mix of IBM Plex Mono and IBM Plex Sans JP. I love it.

## Shell setup (macOS)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [eza](https://github.com/eza-community/eza) - `ls` replacement
- [bat](https://github.com/sharkdp/bat) - A `cat` clone with wings
- [ghq](https://github.com/x-motemen/ghq) - Local Git repository organizer
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering

## Acknowledgments

- [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles)
- [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles)
