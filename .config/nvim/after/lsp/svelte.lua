local typescriptInlayHints = {
  parameterNames = {
    enabled = "literals", -- 'none' | 'literals' | 'all'
    suppressWhenArgumentMatchesName = true,
  },
  parameterTypes = { enabled = false },
  variableTypes = { enabled = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = false },
  enumMemberValues = { enabled = true },
}

---@type vim.lsp.Config
return {
  single_file_support = true,
  settings = {
    svelte = {
      plugin = {
        svelte = {
          -- Disable LSP formatting in favor of prettier via conform.nvim
          format = { enable = false },
        },
      },
    },
    typescript = {
      inlayHints = typescriptInlayHints,
    },
  },
}
