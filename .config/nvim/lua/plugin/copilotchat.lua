---@type LazySpec
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = "CopilotChat",
  build = "make tiktoken",
  keys = {
    { "cpc", "CopilotChat", mode = "ca" },
  },
  dependencies = {
    "zbirenbaum/copilot.lua", -- or github/copilot.vim
    "nvim-lua/plenary.nvim", -- for curl, log wrapper
  },
  opts = {
    debug = false, -- Enable debugging
    chat_autocomplete = true,
    model = "claude-sonnet-4",
    auto_insert_mode = true,
  },
}
