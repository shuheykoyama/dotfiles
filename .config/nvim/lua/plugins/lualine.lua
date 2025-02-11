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

    local function get_hl_color(name, key, default)
      local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
      if ok and hl and hl[key] then
        return string.format("#%06x", hl[key])
      else
        return default
      end
    end

    local function filename_with_icon()
      local filename = vim.fn.expand("%:t")
      if filename == "" then
        return ""
      end

      local ext = vim.fn.expand("%:e")
      if ext ~= "" then
        ext = "." .. ext
      end

      local icon, icon_hl = require("mini.icons").get("file", ext)
      icon = icon or ""

      local icon_fg = get_hl_color(icon_hl, "foreground", "#ffffff")
      local status_bg = get_hl_color("StatusLine", "background", "none")

      -- Create a custom highlight group "MyFileIcon" (matching the foreground color of the icon and the background color of StatusLine)
      vim.api.nvim_set_hl(0, "MyFileIcon", { fg = icon_fg, bg = status_bg })

      -- Apply "MyFileIcon" to the icon and space, then concatenate the file name with the normal highlight
      return string.format("%%#MyFileIcon#%s %%*%s", icon, filename)
    end

    lualine.setup({
      options = {
        -- theme = "github_dark",
        -- theme = "tokyonight-night",
        -- theme = "catppuccin-mocha",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" } },
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
          -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { filename_with_icon },
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
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#c94c16" },
          },
          { "copilot" },
          {
            function()
              return "🎧"
            end,
          },
          -- { "encoding" },
          -- { "fileformat" },
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
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
