---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Gitsigns" },
  keys = {
    { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",            mode = "n", desc = "Stage buffer" },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",              mode = "n", desc = "Stage hunk" },
    { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",         mode = "n", desc = "Undo stage hunk" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",              mode = "n", desc = "Reset hunk" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",            mode = "n", desc = "Preview hunk" },
    { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>",            mode = "n", desc = "Reset buffer" },
    { "<leader>gd", "<cmd>Gitsigns diffthis split=rightbelow<cr>", mode = "n", desc = "Diff this" },
    { "<leader>gb", "<cmd>Gitsigns blame<cr>",                   mode = "n", desc = "Blame" },
    { "<leader>gB", "<cmd>Gitsigns blame_line<cr>",              mode = "n", desc = "Blame line" },
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
    current_line_blame_opts = {
      delay = 2000,
    },
  },
  config = true,
}
