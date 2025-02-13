return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  dependencies = {
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for word under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- blink.cmp の拡張 capabilities を取得
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- 各種診断シンボルの定義
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return string.format("[%s] %s", diagnostic.source, diagnostic.message)
        end,
      },
      float = { border = "rounded" },
    })

    require("lspconfig.ui.windows").default_options.border = "rounded"

    mason_lspconfig.setup_handlers({
      -- デフォルトハンドラ：各サーバーに共通の capabilities を適用
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      -- 各サーバーごとの固有設定
      ["astro"] = function()
        lspconfig["astro"].setup({
          capabilities = capabilities,
          filetypes = { "astro" },
        })
      end,
      ["bashls"] = function()
        lspconfig["bashls"].setup({
          capabilities = capabilities,
          filetypes = { "sh" },
        })
      end,
      ["clangd"] = function()
        lspconfig["clangd"].setup({
          capabilities = capabilities,
          filetypes = { "c", "cpp" },
        })
      end,
      ["cssls"] = function()
        lspconfig["cssls"].setup({
          capabilities = capabilities,
          filetypes = { "css", "scss", "less" },
        })
      end,
      ["html"] = function()
        lspconfig["html"].setup({
          capabilities = capabilities,
          filetypes = { "html" },
        })
      end,
      ["jdtls"] = function()
        lspconfig["jdtls"].setup({
          capabilities = capabilities,
          filetypes = { "java" },
        })
      end,
      ["jsonls"] = function()
        lspconfig["jsonls"].setup({
          capabilities = capabilities,
          filetypes = { "json", "jsonc" },
        })
      end,
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          -- lua_ls 固有の設定と、blink.cmp の capabilities をマージ
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,
      ["marksman"] = function()
        lspconfig["marksman"].setup({
          capabilities = capabilities,
          filetypes = { "markdown", "markdown.mdx" },
        })
      end,
      ["pyright"] = function()
        lspconfig["pyright"].setup({
          capabilities = capabilities,
          filetypes = { "python" },
        })
      end,
      ["ruff"] = function()
        lspconfig["ruff"].setup({
          autostart = false,
        })
      end,
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = { group = "module" },
                prefix = "self",
              },
              cargo = { buildScripts = { enable = true } },
              procMacro = { enable = true },
            },
          },
        })
      end,
      ["tailwindcss"] = function()
        lspconfig["tailwindcss"].setup({
          capabilities = capabilities,
          filetypes = {
            "astro",
            "astro-markdown",
            "css",
            "less",
            "postcss",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        })
      end,
      ["taplo"] = function()
        lspconfig["taplo"].setup({
          capabilities = capabilities,
          filetypes = { "toml" },
        })
      end,
      ["vtsls"] = function()
        lspconfig["vtsls"].setup({
          capabilities = capabilities,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        })
      end,
      ["yamlls"] = function()
        lspconfig["yamlls"].setup({
          capabilities = capabilities,
          filetypes = { "yaml" },
        })
      end,
    })
  end,
}
