---@type vim.lsp.Config
return {
  settings = {
    -- Disable LSP formatting in favor of prettier via conform.nvim
    format = {
      enable = false,
    },
  },
}
