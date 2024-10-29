return {
  "Pocco81/auto-save.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("auto-save").setup({})
  end,
}
