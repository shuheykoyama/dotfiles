return {
  "utilyre/barbecue.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  config = function()
    require("barbecue").setup({
      -- theme = "catppuccin-mocha",
      theme = "tokyonight-storm",
    })
  end,
}
