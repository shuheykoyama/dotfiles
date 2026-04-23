return {
  "echasnovski/mini.splitjoin",
  version = "*",
  keys = {
    { "<leader>j", desc = "Split/Join toggle" },
  },
  opts = { mappings = { toggle = "<leader>j" } },
  config = function(_, opts)
    require("mini.splitjoin").setup(opts)
  end,
}
