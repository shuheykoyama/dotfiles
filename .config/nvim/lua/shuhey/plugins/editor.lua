-- Colors (plugin-independent, runs at import time)
vim.lsp.document_color.enable(false)

return {
  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = "default",
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "none",
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          -- TODO: Specify AI completion
          enabled = vim.g.ai_cmp,
        },
      },

      -- sources = {
      --   -- adding any nvim-cmp sources here will enable them
      --   -- with blink.compat
      --   compat = {},
      --   default = { "lsp", "path", "snippets", "buffer" },
      -- },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },

      keymap = {
        preset = "enter",
        ["c-y"] = { "select_and_accept" },
      },

      appearance = {
        kind_icons = Shuhey.icons.kinds,
      },
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      modes = { insert = true, command = true, terminal = false },
    },
  },
  {
    "craftzdog/mini.diff",
    branch = "feat/grouping",
    event = "VeryLazy",
    opts = {
      view = {
        -- show whole reference part above whole buffer part, as in `git diff`
        overlay_style = "hunk",
      },
      mappings = {
        -- same keymaps as codediff.nvim
        goto_next = "]c",
        goto_prev = "[c",
      },
    },
  },

  -- Comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    keys = {
      { "<leader>gl", mode = { "n", "x" } },
    },
    opts = {},
  },

  -- Colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {
      render = "background",
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_hsl_without_function = true,
      enable_ansi = true,
      enable_var_usage = true,
      enable_tailwind = false,
    },
  },
}
