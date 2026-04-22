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

    local lsp_servers = require("core.lsp_servers")
    local enabled = {}
    vim.list_extend(enabled, lsp_servers.mason_common)
    vim.list_extend(enabled, lsp_servers.non_mason)
    vim.lsp.enable(enabled)
  end,
}
