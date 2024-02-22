# Shuhey's dotfiles - I love Neovim

![alpha-nvim](./images/screenshot_01.png)

| ![neo-tree](./images/screenshot_02.png) | ![show_documentation](./images/screenshot_03.png) | ![nvim-cmp](./images/screenshot_04.png) |
| --------------------------------------- | ------------------------------------------------- | --------------------------------------- |
| 起動画面                                | ドキュメンテーション                              | 補完                                    |

<p>
    <img src="./images/screenshot_02.png" />
    <img src="./images/screenshot_03.png" />
</p>

:::note warn
Warning!
🚨 Before using these config files, it is recommended that you understand what they will set. Use at your own risk
:::

- This dotfiles repository is to make my development environment supremely cool and to keep me happy.
- If you have a better tool or advice on how to do it better, I would be happy to hear it.
- These configs (especially NeoVim config) are based on [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) by [@Takuya](https://github.com/craftzdog). Thank you very much.
- I also referred to many other documents for these configs. Thanks to all open source projects.
- In addition, some of these configs are written with the reliable copilot, ChatGPT.

## Contents

- NeoVim config
- tmux config
- Zsh config

## NeoVim setup

Requires [NeoVim](https://neovim.io/) (>= 0.9.5)

- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - A blazing fast and easy to configure NeoVim statusline written in Lua
- [onsails/lspkind-nvim](https://github.com/onsails/lspkind.nvim) - VSCode-like pictograms
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet Engine for NeoVim written in Lua
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - nvim-cmp source for NeoVim's built-in LSP
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - nvim-cmp source for buffer words
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - A completion engine plugin for NeoVim written in Lua
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - A collection of configurations for NeoVim's built-in LSP
- [jose-elias-alvarez/null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) - Use NeoVim as a language server to inject LSP diagnostics, code actions, and more via Lua
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) - Portable package manager for NeoVim that runs everywhere NeoVim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
- [glepnir/lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) - A light-weight lsp plugin based on NeoVim's built-in LSP with a highly performant UI
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - [Treesitter](https://github.com/tree-sitter/tree-sitter) configurations and abstraction layer for NeoVim
- [kyazdani42/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - Lua `fork` of vim-web-devicons for NeoVim
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - A highly extendable fuzzy finder over lists
- [nvim-telescope/telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim) - File Browser extension for telescope.nvim
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Autopairs
- [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Use treesitter to auto close and auto rename html tag
- [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - A high-performance color highlighter
- [akinsho/nvim-bufferline.lua](https://github.com/akinsho/bufferline.nvim) - A snazzy bufferline
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers
- [dingguy258/git.nvim](https://github.com/dinhhuy258/git.nvim) - A simple clone of the plugin vim-fugitive
- [folke/zen-mode.nvim](https://github.com/folke/zen-mode.nvim) - Distraction-free mode
- [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - Markdown live preview

## Shell setup (macOS)

- [Zsh](https://www.zsh.org/)
- [Sheldon](https://github.com/rossmacarthur/sheldon) - Plugin manager
- [Starship](https://github.com/starship/starship) - Shell theme. I use [No Empty Icons Preset](https://starship.rs/presets/no-empty-icons.html) with some customization
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Powerline-patched fonts. I use [Hack](https://github.com/source-foundry/Hack).
- [z - jump around](https://github.com/rupa/z) - Directory jumping
- [Exa](https://the.exa.website/) - `ls` replacement

## Acknowledgment

<https://github.com/craftzdog/dotfiles-public>

## About me

Shuhey Koyama

- [X](https://twitter.com/shuheykoyama)
- [Facebook](https://www.facebook.com/shuhey.koyama/)
- [Instagram](https://www.instagram.com/shuheykoyama/)
- [YouTube](https://www.youtube.com/channel/UCzPjLzS8qL26bRrBDp4iPyw)
