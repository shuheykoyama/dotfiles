---@type LazySpec
return {
  "echasnovski/mini.operators",
  version = "*",
  keys = {
    { "cx", mode = { "n", "x" }, desc = "Substitute operator" },
    { "cxc", mode = "n", desc = "Substitute line" },
    { "cX", mode = "n", desc = "Substitute to EOL" },
  },
  opts = {
    replace = {
      prefix = "cx",
      reindent_linewise = true,
    },
    -- Other mini.operators (exchange/evaluate/multiply/sort) are intentionally
    -- disabled here to preserve parity with the previous substitute.nvim scope
    -- and to avoid overriding Neovim 0.10+ builtin `gx` (vim.ui.open) and oil's
    -- buffer-local `gx` action. Enable any of them by setting a non-empty
    -- `prefix` when desired.
    exchange = { prefix = "" },
    evaluate = { prefix = "" },
    multiply = { prefix = "" },
    sort = { prefix = "" },
  },
  config = function(_, opts)
    require("mini.operators").setup(opts)

    -- Preserve shuhey's existing substitute.nvim key layout:
    -- - `cxc` substitutes the current line (mini default is `cxx`).
    -- - `cX` substitutes from cursor to end of line (no mini equivalent; use `cx$`).
    vim.keymap.set("n", "cxc", "cxx", { remap = true, desc = "Substitute line" })
    vim.keymap.set("n", "cX", "cx$", { remap = true, desc = "Substitute to EOL" })
  end,
}
