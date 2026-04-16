-- Restore cursor position when opening a file
local restoreCursor = vim.api.nvim_create_augroup("restoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local ml = vim.fn.line([['"]])
    local eol = vim.fn.line("$")
    if 1 < ml and ml <= eol then
      vim.cmd.normal([[g`"]])
    end
  end,
  group = restoreCursor,
})

-- Scroll to center if cursor is in the lower 2/3 of the window on open
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local wh = vim.fn.winheight(0)
    local cl = vim.fn.line(".")
    if tb(vim.fn.empty(vim.bo.buftype)) and cl > wh / 3 * 2 then
      vim.cmd.normal("zz")
      for _ = 0, (wh / 6) do
        vim.cmd.normal(t("<C-y>"))
      end
    end
  end,
  group = restoreCursor,
})

-- Toggle relative line numbers based on mode and focus
local augroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = augroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.cursorcolumn = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = augroup,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.opt.cursorline = true
      vim.opt.cursorcolumn = false
      vim.cmd("redraw")
    end
  end,
})

-- Idle timer: fires User IdleTick event every 1000ms while cursor is idle
local idle_timer_group = vim.api.nvim_create_augroup("idle_timer", { clear = true })
local idle_timer = vim.uv.new_timer()

local function stop_idle_timer()
  if idle_timer:is_active() then
    idle_timer:stop()
  end
end

local function start_idle_timer()
  stop_idle_timer()
  idle_timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      if vim.fn.mode() ~= "c" and vim.api.nvim_get_mode().blocking == false then
        vim.api.nvim_exec_autocmds("User", { pattern = "IdleTick" })
      end
    end)
  )
end

-- Start timer on CursorHold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  group = idle_timer_group,
  callback = start_idle_timer,
  desc = "Start idle timer on CursorHold",
})

-- Stop timer when cursor moves or mode changes
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "InsertLeave", "CmdlineEnter" }, {
  pattern = "*",
  group = idle_timer_group,
  callback = stop_idle_timer,
  desc = "Stop idle timer on cursor move",
})

-- Check if file is modified on various events including IdleTick
local function checktime_if_safe()
  if vim.fn.mode() ~= "c" then
    vim.cmd.checktime()
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI", "WinEnter" }, {
  pattern = "*",
  callback = checktime_if_safe,
  desc = "check if file is modified",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "IdleTick",
  callback = checktime_if_safe,
  desc = "check if file is modified on idle tick",
})

-- Auto-create parent directories on save (replaces mkdir.nvim)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local dir = vim.fn.expand("<afile>:p:h")
    if dir:find("%l+://") ~= 1 and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Remove auto-comment continuation from formatoptions (c=wrap, r=Enter, o=o/O)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "*",
  callback = function()
    vim.opt_local.fo:remove({ "c", "r", "o" })
  end,
  desc = "disable comment in newline",
})

-- Expand all folds when opening a file
local folding = vim.api.nvim_create_augroup("folding", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.cmd.normal("zR")
    end, 0)
  end,
  group = folding,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- フローティングウィンドウ内のターミナル（Snacks dashboard 等）は除外
    if vim.api.nvim_win_get_config(0).relative == "" then
      vim.cmd.startinsert()
    end
  end,
})

-- Restore insert mode when re-entering a terminal buffer
local restore_terminal_mode = vim.api.nvim_create_augroup("restore_terminal_mode", { clear = true })
vim.api.nvim_create_autocmd({ "TermEnter", "TermLeave" }, {
  pattern = "term://*",
  callback = function()
    vim.b.term_mode = vim.fn.mode()
  end,
  group = restore_terminal_mode,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    if vim.b.term_mode == "t" then
      vim.cmd.startinsert()
    end
  end,
  group = restore_terminal_mode,
})

-- Auto-save on InsertLeave and TextChanged
local auto_save_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = auto_save_group,
  pattern = "*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    local filename = vim.api.nvim_buf_get_name(buf)
    if filetype == "bigfile" then
      return
    end
    if
      buftype == ""
      and filetype ~= ""
      and filename ~= ""
      and vim.api.nvim_buf_get_option(buf, "modified")
      and vim.api.nvim_buf_get_option(buf, "modifiable")
    then
      vim.cmd("silent! write")
      local relpath = vim.fn.fnamemodify(filename, ":.")
      vim.notify("AutoSave: saved " .. relpath .. " at " .. vim.fn.strftime("%H:%M:%S"), vim.log.levels.INFO)
    end
  end,
})

-- Disable the concealing in some file formats
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Set ugrep as grepprg when available
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    if tb(vim.fn.executable("ugrep")) then
      vim.opt.grepprg = "ugrep -RInk -j -u --tabs=1 --ignore-files"
      vim.opt.grepformat = "%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m"
    end
  end,
})

-- Remove quit commands (:q, :x, :wq, etc.) from command history
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "c:*",
  callback = function()
    local cmd = vim.fn.histget(":", -1)
    if cmd ~= nil and (cmd == "x" or cmd == "xa" or cmd:match("^w?q?a?!?$")) then
      vim.fn.histdel(":", -1)
    end
  end,
})

-- Track colorscheme name in vim.g.colors_name
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    vim.g.colors_name = args.match
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(args)
    vim.schedule(function()
      vim.g.colorterm = os.getenv("COLORTERM")
      if
        vim.tbl_contains({ "truecolor", "24bit", "rxvt", "" }, vim.g.colorterm)
        and tb(vim.fn.exists("+termguicolors"))
      then
        vim.o.termguicolors = true
        vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
      end
    end)
  end,
})

-- Close special buffers (quickfix, chat windows, etc.) when quitting the last normal window
-- @author kawarimidoll
-- @see https://zenn.dev/vim_jp/articles/ff6cd224fab0c7
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local dominated_by_special_buffers = vim
      .iter(vim.api.nvim_list_wins())
      :map(function(win)
        return vim.api.nvim_win_get_buf(win)
      end)
      :filter(function(buf)
        return buf ~= vim.api.nvim_get_current_buf()
      end)
      :all(function(buf)
        return vim.bo[buf].buftype ~= ""
      end)
    if dominated_by_special_buffers then
      vim.cmd("only!")
    end
  end,
})
