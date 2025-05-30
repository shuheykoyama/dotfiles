return {
  "akinsho/bufferline.nvim",
  lazy = true,
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    { "te", "<Cmd>tabedit<CR>", desc = "New tab" },
  },
  version = "*",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    require("bufferline").setup({
      -- highlights = require("catppuccin.groups.integrations.bufferline").get({
      --   styles = { "bold" },
      -- }),
      options = {
        mode = "tabs",
        -- indicator = {
        --   icon = "▎", -- this should be omitted if indicator style is not 'icon'
        --   style = "icon" and "underline",
        -- },
        buffer_close_icon = "󰅙",
        modified_icon = "",
        diagnostics = "nvim_lsp",
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   local s = " "
        --   for e, n in pairs(diagnostics_dict) do
        --     local sym = e == "error" and " " or (e == "warning" and " " or " ")
        --     s = s .. n .. sym
        --   end
        --   return s
        -- end,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          if level:match("error") then
            return " " .. count
          end
          return ""
        end,
        offsets = {
          {
            filetype = "neo-tree",
            -- text = "Neo-tree",
            -- text_align = "left",
            -- highlight = "Directory",
          },
        },
        show_buffer_close_icons = false,
        show_close_icon = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    })
  end,
}
