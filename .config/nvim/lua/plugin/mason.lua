return {
  "mason-org/mason.nvim",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonUpdate",
  },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = " ",
          package_pending = "󱑤 ",
          package_uninstalled = "󰅙 ",
        },
      },
    })

    vim.schedule(function()
      require("mason-lspconfig").setup({
        ensure_installed = {
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

          -- rust（rustaceanvim が LSP を管理するため vim.lsp.enable には追加しない）
          "rust_analyzer",

          -- java (nvim-jdtls manages LSP lifecycle, not vim.lsp.enable)
          "jdtls",

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
        automatic_enable = false,
      })

      require("mason-tool-installer").setup({
        run_on_start = false,
        integrations = {
          ["mason-null-ls"] = false,
          ["mason-lspconfig"] = false,
          ["mason-nvim-dap"] = false,
        },
        ensure_installed = {
          -- formatters（ryoppippi 準拠）
          "biome",
          "fixjson",
          "prettier",
          "ruff",
          "stylua",
          -- formatters（ユーザー独自）
          "clang-format",
          "shfmt",
          "yamlfmt",
          -- sql
          "sqruff",
          -- linters（ryoppippi 準拠）
          "shellcheck",
          "markdownlint-cli2",
          "hadolint",
          "actionlint",
          "textlint",
          "yamllint",
        },
      })
    end)
  end,
}
