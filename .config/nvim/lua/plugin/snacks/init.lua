---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd

    vim.api.nvim_create_user_command("Bdelete", function()
      Snacks.bufdelete()
    end, { nargs = 0 })
    vim.api.nvim_create_user_command("Bdeleteall", function()
      Snacks.bufdelete.all()
    end, { nargs = 0 })
    vim.api.nvim_create_user_command("Lazygit", function()
      Snacks.lazygit()
    end, { nargs = 0 })
  end,
  keys = {
    -- Picker [[
    {
      ",<cr>",
      function()
        Snacks.picker.picker_actions()
      end,
      desc = "Picker Actions",
    },
    {
      ",,",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart picker",
    },
    {
      ",<space>",
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = "Grep",
    },
    {
      ",b",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep open buffers",
    },
    {
      ",s",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep word under cursor",
      mode = { "n", "x" },
    },
    {
      ",P",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      ",B",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      ",c",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      ",f",
      function()
        Snacks.picker.files({ hidden = true })
      end,
      desc = "Find files",
    },
    {
      ",g",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git branches",
    },
    {
      ",h",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      ",j",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      ",l",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Lazy plugins",
    },
    {
      ",m",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      ",p",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      ",q",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix list",
    },
    {
      ",r",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume picker",
    },
    {
      ",t",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo comments",
    },
    {
      ",i",
      function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      ",z",
      function()
        Snacks.picker.zoxide()
      end,
      desc = "Zoxide",
    },
    {
      ",d",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Diagnostics (buffer)",
    },
    {
      ",D",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics (all)",
    },
    {
      ",S",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP symbols",
    },
    {
      ",u",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo tree",
    },
    -- Trouble-style <leader>x*/<leader>c* aliases (migrated from trouble.nvim)
    {
      "<leader>xx",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>xX",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>cs",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Document Symbols",
    },
    {
      -- Closest equivalent to `Trouble lsp` (combined definitions/references/implementations
      -- tree). Snacks has no combined picker, so map to references which is the most common
      -- use. For individual views, use gd/gt/gI/gr (LSP on_attach keymaps).
      "<leader>cS",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "LSP references",
    },
    {
      "<leader>xL",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>xQ",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    -- Picker ]]
    -- Dim [[
    {
      "<leader>d",
      function()
        if Snacks.dim.enabled then
          Snacks.dim.disable()
        else
          Snacks.dim.enable()
        end
      end,
      desc = "Dim",
    },
    -- Dim ]]
    -- lazygit [[
    {
      "<leader>g",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log",
    },
    {
      "<leader>gk",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Log File",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    -- lazygit ]]
    -- zen [[
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Zen",
    },
    -- zen ]]
    -- terminal [[
    {
      "<leader>/",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    -- terminal ]]
    -- zoom [[
    {
      "<leader>sm",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Maximize/minimize a split",
    },
    -- zoom ]]
    -- notification [[
    {
      "<leader>n",
      function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    -- notification ]]
    -- scratch [[
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    -- scratch ]]
    -- registers [[
    {
      '"',
      function() Snacks.picker.registers() end,
      mode = { "n", "x" },
      desc = "Registers (copy to default)",
    },
    {
      "<C-r>",
      function() Snacks.picker.registers({ confirm = { "paste", "close" } }) end,
      mode = "i",
      desc = "Registers (paste at cursor)",
    },
    -- registers ]]
  },
  ---@type snacks.Config
  opts = {
    input = {
      enabled = true,
    },
    picker = {
      ui_select = true,
      formatters = {
        file = {
          filename_first = true,
          truncate = 400,
        },
      },
      matcher = {
        frecency = true,
      },
    },
    bigfile = {
      enabled = true,
    },
    words = {
      enabled = true,
      debounce = 500,
    },
    notifier = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
    },
    scratch = {
      enabled = true,
    },
    debug = {
      enabled = true,
    },
    lazygit = {
      enabled = true,
      win = {
        backdrop = false,
      },
    },
    zen = {
      enabled = true,
    },
    styles = {
      notification = {
        wo = { wrap = true },
      },
      lazygit = {
        border = "rounded",
        wo = {
          winhighlight = "Normal:Normal,NormalNC:NormalNC,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
        },
      },
    },
    dashboard = vim.tbl_extend("force", { enabled = true }, require("plugin.snacks.dashboard")),
  },
  config = function(_, opts)
    local notify = vim.notify
    require("snacks").setup(opts)
    -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
    -- this is needed to have early notifications show up in noice history
    if require("lazy.core.config").spec.plugins["noice.nvim"] then
      vim.notify = notify
    end
  end,
}
