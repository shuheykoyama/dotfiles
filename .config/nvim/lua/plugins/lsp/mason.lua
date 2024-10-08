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
        "jdtls",
        "vtsls",
        "jsonls",
        "lua_ls",
        "marksman",
        -- "intelephense",
        "rust_analyzer",
        "tailwindcss",
        "taplo",
        "yamlls",
        "pyright",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "shfmt",
        "shellcheck",
        "clang-format",
        "prettierd",
        "stylua", -- lua formatter
        "google-java-format",
        "checkstyle",
        "eslint_d", -- js linter
        "selene",
        "markdownlint",
        -- "pint",
        -- "phpstan",
        "rustfmt",
        "ruff",
      },
    })
  end,
}
