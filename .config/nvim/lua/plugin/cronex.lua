---@type LazySpec
local patterns = {
  "*.yaml",
  "*.yml",
  "*.tf",
  "*.cfg",
  "*.config",
  "*.conf",
  "*.json",
  "*.ts",
  "*.js",
}

return {
  "fabridamicelli/cronex.nvim",
  -- Scope the load event to file_patterns so cronex only loads when a
  -- cron-relevant file is opened, instead of on every BufReadPost (~3.3ms
  -- on any file open). The annotated-file set stays identical: cronex's
  -- internal BufEnter autocmd is already pattern-gated to file_patterns, and
  -- BufReadPost fires before BufEnter so the initial annotation is not missed.
  event = vim.tbl_map(function(pattern)
    return "BufReadPost " .. pattern
  end, patterns),
  opts = {
    file_patterns = patterns,
    explainer = {
      cmd = { "bun", "x", "cronstrue" },
    },
  },
}
