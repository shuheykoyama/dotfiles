---@type LazySpec
return {
  "adlrwbr/keep-split-ratio.nvim",
  event = "VeryLazy",
  opts = {
    -- We already set `equalalways = false` explicitly in
    -- lua/config/options.lua:85, so this prevents the plugin from
    -- redundantly reassigning the same value at setup time. The plugin's
    -- ratio-preservation behavior is unaffected.
    manage_equalalways = false,
  },
}
