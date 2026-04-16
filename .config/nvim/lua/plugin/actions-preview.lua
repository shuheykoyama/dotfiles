---@type LazySpec
return {
  "aznhe21/actions-preview.nvim",
  event = "LspAttach",
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/snacks.nvim",
  },
  opts = {
    backend = { "snacks" },
    snacks = {
      layout = {
        preset = "vertical",
        layout = { height = 0.4 },
      },
    },
  },
}
