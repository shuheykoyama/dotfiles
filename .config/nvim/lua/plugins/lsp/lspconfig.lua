return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  dependencies = {
    "saghen/blink.cmp",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- LSP capabilities from blink.cmp
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Diagnostic configuration with signs (using native API)
    vim.diagnostic.config({
      signs = {
        Error = " ",
        Warn = " ",
        Hint = "󰠠 ",
        Info = " ",
      },
      virtual_text = {
        format = function(d)
          return string.format("[%s] %s", d.source, d.message)
        end,
      },
      float = { border = "rounded" },
    })
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- on_attach callback to map keys after LSP attaches to buffer
    local on_attach = function(client, bufnr)
      local km = vim.keymap
      local opts = { buffer = bufnr, silent = true }
      km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
      km.set("n", "gD", vim.lsp.buf.declaration, opts)
      km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
      km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
      km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      km.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      km.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
      km.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      km.set("n", "[d", vim.diagnostic.goto_prev, opts)
      km.set("n", "]d", vim.diagnostic.goto_next, opts)
      km.set("n", "K", vim.lsp.buf.hover, opts)
      km.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end

    -- Apply defaults to all servers via native API
    vim.lsp.config("*", { on_attach = on_attach, capabilities = capabilities })

    -- Server-specific overrides
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })

    -- Manual setup for servers not covered by native config (e.g., sourcekit)
    local lspconfig = require("lspconfig")
    if lspconfig.sourcekit then
      lspconfig.sourcekit.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "sourcekit-lsp",
          "-Xswiftc",
          "-sdk",
          "/Applications/Xcode.app/Contents/Developer/Platforms/"
            .. "iPhoneSimulator.platform/Developer/SDKs/"
            .. "iPhoneSimulator18.2.sdk",
          "-Xswiftc",
          "-target",
          "x86_64-apple-ios18.2-simulator",
        },
        filetypes = { "swift" },
      })
    end
  end,
}
