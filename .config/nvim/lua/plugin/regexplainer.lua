---@type LazySpec
return {
  "bennypowers/nvim-regexplainer",
  -- keys-based lazy-load keeps startup cost at zero (perf-friendly, unlike
  -- event=). v2.0.0 dropped the nui.nvim/plenary deps (native APIs now), so
  -- narrative+popup needs no dependencies block -- only the `regex` treesitter
  -- parser, installed via :TSInstall regex.
  keys = { { "gR", desc = "Regexplainer toggle" } },
  opts = {
    display = "popup",
    mappings = { toggle = "gR" },
  },
}
