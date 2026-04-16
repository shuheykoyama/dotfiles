local o = {}

---Typescript inlay hints config
o.typescriptInlayHints = {
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

---Format config
---@param enabled boolean
function o.format_config(enabled)
  return function(client)
    client.server_capabilities.documentFormattingProvider = enabled
    client.server_capabilities.documentRangeFormattingProvider = enabled
  end
end

return o
