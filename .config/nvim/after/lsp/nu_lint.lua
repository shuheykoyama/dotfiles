---@type vim.lsp.Config
return {
  cmd = { "nu-lint", "lsp" },
  filetypes = { "nu" },
  root_markers = { ".git" },
}
