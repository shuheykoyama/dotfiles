return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    "catppuccin",
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
    "AndreM222/copilot-lualine",
  },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    lualine.setup({
      options = {
        theme = "tokyonight-storm",
        -- theme = "catppuccin-mocha",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            separator = { right = "" },
          },
        },
        lualine_b = {
          {
            "filename",
            color = { bg = "#45475a" },
            separator = { right = "" },
          },
          {
            "branch",
          },
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
          { "copilot" },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
          {
            "progress",
            color = { bg = "#45475a" },
            separator = { left = "" },
          },
        },
        lualine_z = {
          {
            "location",
            separator = { left = "" },
          },
          -- {
          --   "datetime",
          --   style = " %H:%M",
          --   separator = { left = "" },
          --   -- left_padding = 2,
          -- },
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            "filename",
            separator = { right = "" },
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
