return {
  -- File explorer
  {
    "stevearc/oil.nvim",
    -- Not lazy-loaded so that `nvim <dir>` opens oil.
    lazy = false,
    opts = {
      columns = {
        "icon",
        { "permissions", highlight = "Type" },
        { "size", highlight = "String" },
        { "mtime", highlight = "Keyword" },
      },
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        max_width = 200,
      },
      preview_win = {
        update_on_cursor_moved = true,
      },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-l>",
          accept_line = "<M-S-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- csv / tsv column colors
  {
    "mechatroner/rainbow_csv",
    ft = { "csv" },
  },

  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>LivePreview start<cr>",
        desc = "Live Preview",
      },
    },
    opts = {
      -- Serve from the current file's parent directory so relative asset paths
      -- (./img.png, ../assets/) resolve correctly — matches how markdown files
      -- (incl. Obsidian notes) reference images.
      dynamic_root = true,
      -- Reuse the existing snacks picker for `:LivePreview pick` instead of
      -- letting it auto-detect telescope/fzf-lua/mini.pick (none installed here).
      picker = "snacks.picker",
    },
    config = function(_, opts)
      require("livepreview.config").set(opts)
    end,
  },

  -- quickfix (same specs as ryoppippi/dotfiles)
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").enable()
    end,
  },
  {
    "https://github.com/stevearc/quicker.nvim",
    ft = { "qf" },
    keys = {
      {
        "<leader>R",
        function()
          require("quicker").refresh()
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "qf",
        once = true,
        callback = function()
          local refresh = require("quicker").refresh

          refresh()
        end,
      })
    end,
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
