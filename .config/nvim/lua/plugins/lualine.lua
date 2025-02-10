return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    -- "catppuccin",
    "lewis6991/gitsigns.nvim",
    -- "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
    "AndreM222/copilot-lualine",
    "SmiteshP/nvim-navic",
  },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    local navic = require("nvim-navic")

    lualine.setup({
      options = {
        -- theme = "github_dark",
        theme = "tokyonight-night",
        -- theme = "catppuccin-mocha",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
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
          { "filetype", icon_only = true, separator = "", padding = { left = 1.5, right = 0 } },
          { "filename" },
          {
            "navic",
            color_correction = "static",
            navic_opts = nil,
            -- function()
            --   return navic.get_location()
            -- end,
            -- cond = function()
            --   return navic.is_available()
            -- end,
          },
        },
        lualine_x = {
          { "diagnostics" },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "copilot" },
          { "encoding" },
          { "fileformat" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {
          {
            "filename",
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
