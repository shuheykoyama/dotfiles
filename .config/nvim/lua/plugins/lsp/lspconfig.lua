return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        -- opts.desc = "Show LSP definitions"
        -- keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
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
      float = {
        border = "rounded",
      },
    })

    require("lspconfig.ui.windows").default_options.border = "rounded"

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["astro"] = function()
        -- configure astro server
        lspconfig["astro"].setup({
          capabilities = capabilities,
          filetypes = { "astro" },
        })
      end,
      ["bashls"] = function()
        -- configure bash server
        lspconfig["bashls"].setup({
          capabilities = capabilities,
          filetypes = { "sh" },
        })
      end,
      ["clangd"] = function()
        -- configure c/c++ server
        lspconfig["clangd"].setup({
          capabilities = capabilities,
          filetypes = { "c", "cpp" },
        })
      end,
      ["cssls"] = function()
        -- configure css/scss server
        lspconfig["cssls"].setup({
          capabilities = capabilities,
          filetypes = { "css", "scss", "less" },
        })
      end,
      ["html"] = function()
        -- configure html server
        lspconfig["html"].setup({
          capabilities = capabilities,
          filetypes = { "html" },
        })
      end,
      ["jdtls"] = function()
        -- configure java server
        lspconfig["jdtls"].setup({
          capabilities = capabilities,
          filetypes = { "java" },
        })
      end,
      ["vtsls"] = function()
        -- configure javascript/typescript server with plugin
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
      ["jsonls"] = function()
        -- configure json server
        lspconfig["jsonls"].setup({
          capabilities = capabilities,
          filetypes = { "json", "jsonc" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["marksman"] = function()
        -- configure markdown server
        lspconfig["marksman"].setup({
          capabilities = capabilities,
          filetypes = { "markdown", "markdown.mdx" },
        })
      end,
      -- ["intelephense"] = function()
      --   -- configure php server
      --   lspconfig["intelephense"].setup({
      --     capabilities = capabilities,
      --     on_attach = on_attach,
      --     root_dir = function()
      --       return vim.loop.cwd()
      --     end,
      --   })
      -- end,
      ["rust_analyzer"] = function()
        -- configure rust server
        lspconfig["rust_analyzer"].setup({
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        })
      end,
      ["tailwindcss"] = function()
        -- configure tailwindcss server
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
        -- configure toml server
        lspconfig["taplo"].setup({
          capabilities = capabilities,
          filetypes = { "toml" },
        })
      end,
      ["yamlls"] = function()
        -- configure yaml server
        lspconfig["yamlls"].setup({
          capabilities = capabilities,
          filetypes = { "yaml" },
        })
      end,
      ["pyright"] = function()
        -- configure python server
        lspconfig["pyright"].setup({
          capabilities = capabilities,
          filetypes = { "python" },
        })
      end,
    })
  end,
}
