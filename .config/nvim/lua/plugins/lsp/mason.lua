return {
  "williamboman/mason.nvim",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonUpdate",
  },
  -- event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = " ",
          package_pending = "󱑤 ",
          package_uninstalled = "󰅙 ",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "astro",
        "bashls",
        "clangd",
        "cssls",
        "html",
        -- "intelephense",
        "jdtls",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "rust_analyzer",
        -- "sourcekit",
        "tailwindcss",
        "taplo",
        "vtsls",
        "yamlls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "biome",
        "checkstyle",
        "clang-format",
        "eslint_d", -- js linter
        "google-java-format",
        "markdownlint",
        -- "phpstan",
        -- "pint",
        "prettierd",
        "ruff",
        "rustfmt",
        "selene",
        "shellcheck",
        "shfmt",
        "stylua", -- lua formatter
      },
    })
  end,
}
