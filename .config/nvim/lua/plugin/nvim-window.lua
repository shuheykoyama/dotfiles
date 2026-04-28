---@type LazySpec
return {
  "yorickpeterse/nvim-window",
  keys = {
    {
      "<Leader><cr>",
      function() require("nvim-window").pick() end,
      desc = "Pick window",
    },
  },
  opts = {
    -- Homerow-priority labels carried over from the previous chowcho.nvim
    -- setup: right-hand index/middle/ring keys first, then outer columns
    -- and the bottom row, so picks resolved in 1 keystroke land on the
    -- easiest keys.
    chars = {
      "h", "j", "k", "l", "u", "i", "o", "p", "n", "m",
      "y", "t", "g", "b", "v", "c", "r", "e", "w", "q",
      "s", "x", "z", "a", "f", "d",
    },
    -- Match the rounded-border style this config uses for other floating
    -- UIs (lspconfig hover, mason, snacks lazygit, diagnostic float).
    border = "rounded",
  },
}
