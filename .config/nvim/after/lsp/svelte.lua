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
  on_attach = function(client, _)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end,
  single_file_support = true,
  settings = {
    format = {
      enable = false,
    },
    typescript = {
      inlayHints = typescriptInlayHints,
    },
  },
}
