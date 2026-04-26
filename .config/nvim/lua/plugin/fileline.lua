return {
  "lewis6991/fileline.nvim",
  -- fileline.nvim only registers a BufNewFile autocmd internally; BufReadPre
  -- would just load the plugin without anything to do.
  event = "BufNewFile",
}
