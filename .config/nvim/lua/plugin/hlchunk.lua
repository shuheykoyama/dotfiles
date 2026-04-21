return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = { enable = true },
      indent = { enable = true },
    })
  end,
}
