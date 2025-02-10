return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   event = "VimEnter",
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     require("catppuccin").setup({
  --       transparent_background = true,
  --       styles = {
  --         comments = { "italic" },
  --         conditionals = {},
  --         loops = {},
  --         functions = { "italic" },
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = { "italic" },
  --         operators = {},
  --       },
  --       integrations = {
  --         barbar = true,
  --         lsp_trouble = true,
  --         mason = true,
  --         mini = {
  --           indentscope_color = "mauve",
  --         },
  --         native_lsp = {
  --           underlines = {
  --             errors = { "undercurl" },
  --             hints = { "undercurl" },
  --             warnings = { "undercurl" },
  --             information = { "undercurl" },
  --           },
  --         },
  --         neotree = true,
  --         noice = true,
  --         notify = true,
  --         symbols_outline = true,
  --         which_key = true,
  --       },
  --     })
  --     vim.cmd([[colorscheme catppuccin-mocha]])
  --   end,
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          comments = { italic = true },
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd([[colorscheme solarized-osaka]])
  --   end,
  -- },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("github-theme").setup({
  --       options = {
  --         transparent = true,
  --         styles = {
  --           comments = "italic",
  --         },
  --       },
  --     })
  --     vim.cmd([[colorscheme github_dark]])
  --   end,
  -- },
}
