return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  dependencies = {
    "saghen/blink.cmp",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",
  },
  init = function()
    require("core.plugin").on_attach(function(client, bufnr)
      if vim.tbl_contains({ "oil" }, vim.bo.filetype) then
        return
      end
      local on_attach = require("plugin.nvim-lspconfig.on_attach")
      on_attach(client, bufnr)
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    end)

    vim.api.nvim_create_user_command("LspDiagnosticReset", function()
      vim.diagnostic.reset()
    end, {})
  end,
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    require("lspconfig.ui.windows").default_options.border = "rounded"
    vim.lsp.config("*", { capabilities = capabilities })
    vim.lsp.enable({
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

      -- fish (fish-lsp is not in Mason; install via: brew install fish-lsp)
      "fish_lsp",

      -- bash
      "bashls",

      -- swift
      "sourcekit",

      -- python
      "basedpyright",
      "ruff",

      -- c/c++
      "clangd",

      -- sql
      "postgres_lsp",
      "sqruff",

      -- misc
      "typos_lsp",
    })
  end,
}
