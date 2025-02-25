# Shuhey's dotfiles

![thumbnail](./images/nvim_screenshot_01.png)

<p align="center">
  <img src="./images/nvim_screenshot_02.png" alt="coding_astro" width="49%">
  <img src="./images/nvim_screenshot_03.png" alt="show_documentation" width="49%">
</p>

## I love Neovim

- This dotfiles repository is to make my development environment supremely cool and to keep me happy.
- If you have a better tool or advice on how to do it better, I would be happy to hear it.
- These configs (especially Neovim config) are based on [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) and [josean-dev/dev-environment-files](https://github.com/josean-dev/dev-environment-files). Thank you very much.
- I also referred to many other documents for these configs. Thanks to all open source projects.
- In addition, some of these configs are written with the reliable copilot, ChatGPT and Claude.

🚨 Before using these config files, it is recommended that you understand what they will set. Use at your own risk.

## Contents

- Neovim config
- Ghostty config
- starship config
- Zsh config
- Git config
- Zellij config

## Neovim setup

### Requirements

- [Neovim](https://neovim.io/) >= **v0.9.0** (need to be built with **LuaJIT**)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that support true color and _undercurl_:
  - I love [Ghostty](https://ghostty.org/) 👻
- [Solarized Osaka](https://github.com/craftzdog/solarized-osaka.nvim)

## Shell setup (macOS)

- [Zsh](https://www.zsh.org/)
- [sheldon](https://github.com/rossmacarthur/sheldon) - Plugin manager
- [starship](https://github.com/starship/starship) - Shell theme
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts for development-use. I use [PlemolJP](https://github.com/yuru7/PlemolJP).
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Directory jumping
- [eza](https://github.com/eza-community/eza) - A modern alternative to `ls`
- [bat](https://github.com/sharkdp/bat) - A `cat` clone with wings
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder
- [Zellij](https://github.com/zellij-org/zellij) - A terminal workspace alternative to `tmux`

## Acknowledgments

- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) - My aspiring individual developer's dotfiles
- [josean-dev/dev-environment-files](https://github.com/josean-dev/dev-environment-files) - Cool dev environment
