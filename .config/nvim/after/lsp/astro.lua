---@type vim.lsp.Config
return {
  on_attach = function(client)
    -- astro-ls has no setting to turn its prettier-based formatting off, so drop
    -- the capability. Formatting is left to conform.nvim.
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
