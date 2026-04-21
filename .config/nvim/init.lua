vim.loader.enable()

-- Interactive startup profiling via Snacks.profiler.
-- Run: `PROF=1 nvim foo.lua` to open the profile picker after startup.
-- This is loaded early (before lazy.nvim) so it can capture the full cascade.
if vim.env.PROF then
  local snacks_path = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks_path)
  require("snacks.profiler").startup({
    startup = { event = "UIEnter", after = true },
  })
end

require("config")
