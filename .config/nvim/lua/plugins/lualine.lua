return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    "catppuccin",
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    lualine.setup({
      options = {
        -- theme = "tokyonight",
        theme = "catppuccin-mocha",
        component_separators = "|",
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            separator = { left = "", right = "" },
            right_padding = 2,
          },
        },
        lualine_b = {
          { "filename" },
          { "branch" },
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          { "diagnostics" },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
          { "progress" },
          { "location" },
        },
        lualine_z = {
          {
            "datetime",
            style = " %H:%M",
            separator = { left = "", right = "" },
            left_padding = 2,
          },
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            "filename",
            separator = { left = "", right = "" },
            right_padding = 2,
            color = { bg = "#45475a" },
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      -- extensions = { "neo-tree", "lazy" },
    })
  end,
}
