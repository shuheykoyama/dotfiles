-- Single source of truth for LSP server lists.
-- Consumed by lua/plugin/nvim-lspconfig/init.lua and lua/plugin/mason.lua.
return {
  -- Mason-managed + activated via vim.lsp.enable (lifecycle via nvim core).
  mason_common = {
    -- config files
    "jsonls",
    "yamlls",
    "gh_actions_ls",
    "dockerls",
    "docker_compose_language_service",

    -- web/javascript
    "svelte",
    "vtsls",
    "prismals",
    "astro",
    "biome",
    "eslint",
    "oxlint",
    "emmet_ls",
    "tailwindcss",
    "cssmodules_ls",
    "unocss",
    "html",
    "stylelint_lsp",
    "oxfmt",

    -- lua
    "lua_ls",

    -- markdown
    "markdown_oxide",

    -- python
    "basedpyright",
    "ruff",

    -- bash
    "bashls",

    -- c/c++
    "clangd",

    -- sql
    "postgres_lsp",
    "sqruff",

    -- misc
    "typos_lsp",
  },

  -- Mason-installed but lifecycle managed by a separate plugin.
  -- Listed here so mason ensure_installed covers them, but NOT passed to vim.lsp.enable.
  mason_external = {
    "rust_analyzer", -- rustaceanvim manages the rust-analyzer client
    "jdtls",         -- nvim-jdtls manages the jdtls client
  },

  -- Not in Mason; installed via system package manager.
  -- Passed to vim.lsp.enable but NOT to mason ensure_installed.
  non_mason = {
    "fish_lsp",  -- brew install fish-lsp
    "sourcekit", -- ships with Xcode
  },
}
