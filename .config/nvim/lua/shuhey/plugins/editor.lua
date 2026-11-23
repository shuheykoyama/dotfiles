-- Colors (plugin-independent, runs at import time)
vim.lsp.document_color.enable(false)

local oxfmtFormatter = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

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
    opts = {},
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          javascript = oxfmtFormatter,
          typescript = oxfmtFormatter,
          javascriptreact = oxfmtFormatter,
          typescriptreact = oxfmtFormatter,
          json = oxfmtFormatter,
          css = oxfmtFormatter,
          html = oxfmtFormatter,
          markdown = oxfmtFormatter,
          yaml = oxfmtFormatter,
          less = oxfmtFormatter,
          scss = oxfmtFormatter,
          ["markdown.mdx"] = oxfmtFormatter,
          svelte = oxfmtFormatter,
          astro = oxfmtFormatter,
          lua = { "stylua" },
          sh = { "shfmt" },
          fish = { "fish_indent" },
          python = { "ruff_format" },
          swift = { "swiftformat" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          sql = { "sqruff" },
          nu = { "nufmt" },
        },
        formatters = {
          oxfmt = {
            -- Treat oxfmt as available only when the project has an oxfmt config
            -- (.oxfmtrc.json / .oxfmtrc.jsonc). Without it, oxfmt is skipped and the
            -- formatter list falls back to prettier.
            require_cwd = true,
          },
          -- Prefer the project's own ruff (.venv/bin/ruff, e.g. a uv dev dependency) so the
          -- version matches the project; otherwise use the Mason one from PATH.
          ruff_format = {
            command = require("conform.util").find_executable({ ".venv/bin/ruff" }, "ruff"),
          },
          -- nufmt looks up nufmt.nuon from the cwd upwards, so run it at the project root
          nufmt = {
            cwd = require("conform.util").root_file({ ".git" }),
          },
        },
        format_on_save = function(bufnr)
          if vim.b[bufnr].disable_autoformat then
            return
          end
          return {
            timeout_ms = 500,
            lsp_fallback = true,
          }
        end,
      }
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    ft = "swift",
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        swift = { "swiftlint" },
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      -- The first swift buffer has already been read by the time this plugin loads.
      lint.try_lint()
    end,
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
