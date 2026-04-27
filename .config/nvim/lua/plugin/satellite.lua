return {
  "lewis6991/satellite.nvim",
  event = "VeryLazy",
  dependencies = {
    "lewis6991/gitsigns.nvim",
  },
  opts = {
    -- Special non-floating buffers where the scrollbar adds visual noise but
    -- no useful information: dashboard, lazy.nvim UI, oil file browser, help.
    -- (Floating windows like Snacks pickers, lazygit, scratch are already
    -- excluded automatically by satellite's `is_ordinary_window` check.)
    excluded_filetypes = { "snacks_dashboard", "lazy", "oil", "help" },
  },
}
