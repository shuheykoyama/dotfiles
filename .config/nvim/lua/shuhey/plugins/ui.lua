local icons = Shuhey.icons
local lazygit_utils = require("shuhey.utils.lazygit")

-- Plugin-independent setup runs at import time (before lazy loads any plugin).
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
})

return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "vivid",
      transparent = true,
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd.colorscheme("solarized-osaka")

      -- Custom tabline setup
      require("shuhey.utils.tabline").setup()
      vim.o.showtabline = 1
      vim.o.tabline = "%!v:lua.require('shuhey.utils.tabline').render()"
    end,
  },
  {
    "nvim-mini/mini.icons",
    lazy = false,
    priority = 900,
    config = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      indent = { enabled = true },
      scroll = { enabled = false },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
        layouts = {
          default = { layout = { width = 0.9, height = 0.9 } },
        },
      },
      notifier = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = {
        enabled = true,
        configure = true, -- auto-sets nvim-remote preset & syncs theme
        config = {
          -- Open files selected in lazygit in the pane it was launched from,
          -- instead of the nvim-remote preset's new tab. See utils/lazygit.lua.
          os = {
            edit = lazygit_utils.edit_command(),
            editAtLine = lazygit_utils.edit_command({ at_line = true }),
          },
        },
        theme = {
          activeBorderColor = { fg = "WarningMsg", bold = true },
        },
      },
    },
  },
}
