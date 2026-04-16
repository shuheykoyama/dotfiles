---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
  cmd = { "Gitsigns" },
  keys = {
    { "ms", "Gitsigns", mode = "ca" },
    { "mS", "<cmd>Gitsigns stage_buffer<cr>", mode = "n" },
    { "ms", "<cmd>Gitsigns stage_hunk<cr>", mode = "n" },
    { "mu", "<cmd>Gitsigns undo_stage_hunk<cr>", mode = "n" },
    { "mr", "<cmd>Gitsigns reset_hunk<cr>", mode = "n" },
    { "mp", "<cmd>Gitsigns preview_hunk<cr>", mode = "n" },
    { "mR", "<cmd>Gitsigns reset_buffer<cr>", mode = "n" },
    { "md", "<cmd>Gitsigns diffthis split=rightbelow<cr>", mode = "n" },
    { "mB", "<cmd>Gitsigns blame<cr>", mode = "n" },
    { "mb", "<cmd>Gitsigns blame_line<cr>", mode = "n" },
  },
  dependencies = {
    "tpope/vim-repeat",
  },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~_" },
    },
    current_line_blame = true,
  },
  config = true,
}
