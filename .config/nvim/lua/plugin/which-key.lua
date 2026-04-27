return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    plugins = {
      registers = false,
    },
    spec = {
      { "<leader>sn", group = "noice" },
    },
  },
}
