---@type vim.lsp.Config
return {
  on_attach = function(client)
    -- hover は basedpyright に任せる
    client.server_capabilities.hoverProvider = false
    -- フォーマットは conform.nvim（uv run ruff format）に任せる
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
