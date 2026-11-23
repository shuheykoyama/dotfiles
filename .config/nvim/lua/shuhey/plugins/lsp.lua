return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "tree-sitter-cli",
        "lua-language-server",
        "prettier",
        "prettierd",
        "shellcheck",
        "shfmt",
        "stylua",
        "eslint-lsp",
        "oxlint",
        "oxfmt",
        "tailwindcss-language-server",
        "vtsls",
        "copilot-language-server",
        "rust-analyzer",
        -- css-lsp provides vscode-css-language-server (cssls); glsl_analyzer is enabled below
        "css-lsp",
        "glsl_analyzer",
        -- languages kept from the previous setup
        "html-lsp",
        "superhtml",
        "svelte-language-server",
        "astro-language-server",
        "rumdl",
        "pyrefly",
        "ruff",
        "bash-language-server",
        "clangd",
        "clang-format",
        "sqruff",
        "postgres-language-server",
        "jdtls",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- mason must be set up before any server starts so its bin directory is on PATH.
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      local capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
      })

      vim.lsp.enable({
        "eslint",
        "oxlint",
        "lua_ls",
        "cssls",
        "vtsls",
        "tailwindcss",
        "glsl_analyzer",
        -- rust_analyzer is started by rustaceanvim
        "html",
        "superhtml",
        "svelte",
        "astro",
        "pyrefly",
        "ruff",
        "rumdl",
        "bashls",
        "fish_lsp",
        "nushell",
        "nu_lint",
        "clangd",
        "sourcekit",
        "jdtls",
        "postgres_lsp",
        "sqruff",
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
  },
}
