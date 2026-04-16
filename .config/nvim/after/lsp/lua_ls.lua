local lsp_utils = require("plugin.nvim-lspconfig.utils")
local format_config = lsp_utils.format_config

---@type vim.lsp.Config
return {
  on_attach = format_config(false),
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        checkThirdParty = "Disable",
      },
      diagnostics = {
        globals = { "vim" },
      },
      completion = {
        showWord = "Disable",
        callSnippet = "Replace",
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
      },
    },
  },
}
