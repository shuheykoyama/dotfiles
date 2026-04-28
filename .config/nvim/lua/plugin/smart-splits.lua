---@type LazySpec
return {
  "mrjones2014/smart-splits.nvim",
  init = function()
    -- Skip the multiplexer auto-detection probe and prevent
    -- `mux_utils.startup()` from registering zellij CLI autocmds on
    -- VimResume / VimEnter / VimResized / FocusGained. We don't wire up
    -- move_cursor_* keymaps (cross-mux navigation is unused), so all the
    -- mux-side work is wasted. Setting `vim.g` here ensures the probe
    -- inside `plugin/smart-splits.lua` early-returns when the plugin
    -- finally loads on first <C-h/j/k/l> press.
    --
    -- Documented pattern from the smart-splits README:
    --   "You can also set the desired multiplexer integration in lazy
    --    environments before the plugin is loaded by setting
    --    vim.g.smart_splits_multiplexer_integration."
    vim.g.smart_splits_multiplexer_integration = false
  end,
  opts = {
    -- The upstream default `{ "NvimTree" }` doesn't match anything in this
    -- config (oil is the file browser). Drop the dead entry.
    ignored_filetypes = {},
  },
  keys = {
    -- resize
    { "<C-h>", function() require("smart-splits").resize_left() end,   desc = "Resize left" },
    { "<C-j>", function() require("smart-splits").resize_down() end,   desc = "Resize down" },
    { "<C-k>", function() require("smart-splits").resize_up() end,     desc = "Resize up" },
    { "<C-l>", function() require("smart-splits").resize_right() end,  desc = "Resize right" },
    -- swap buffers
    { "<leader><leader>h", function() require("smart-splits").swap_buf_left() end,  desc = "Swap buffer left" },
    { "<leader><leader>j", function() require("smart-splits").swap_buf_down() end,  desc = "Swap buffer down" },
    { "<leader><leader>k", function() require("smart-splits").swap_buf_up() end,    desc = "Swap buffer up" },
    { "<leader><leader>l", function() require("smart-splits").swap_buf_right() end, desc = "Swap buffer right" },
  },
}
