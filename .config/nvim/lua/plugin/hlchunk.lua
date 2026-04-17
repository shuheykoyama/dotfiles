return {
  "shellRaining/hlchunk.nvim",
  event = { "VeryLazy" },
  config = function()
    require("hlchunk").setup({
      chunk = { enable = true },
      indent = { enable = true },
    })
  end,
}
