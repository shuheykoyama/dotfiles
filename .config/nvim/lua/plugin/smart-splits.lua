---@type LazySpec
return {
  "mrjones2014/smart-splits.nvim",
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
