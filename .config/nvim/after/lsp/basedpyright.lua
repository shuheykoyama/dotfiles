---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- ruff handles import organization
    },
  },
}
