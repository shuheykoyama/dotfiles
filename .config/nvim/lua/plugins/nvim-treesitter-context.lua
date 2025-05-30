return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    max_lines = 3,
    mode = "cursor",
  },
}
