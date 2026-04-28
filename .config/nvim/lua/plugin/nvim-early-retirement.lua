return {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
  opts = {
    -- persistence.nvim restores `"buffers"` from session files in
    -- unloaded state (entries appear in the buffer list but their content
    -- isn't read yet). With the upstream default `false`, those entries
    -- get closed after 20 min like any other inactive buffer, which
    -- defeats the point of saving the buffer list in the persistence opts.
    -- Treat unloaded buffers as ignored so the session history survives.
    ignoreUnloadedBufs = true,
  },
}
