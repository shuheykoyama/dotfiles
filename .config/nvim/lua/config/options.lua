vim.cmd("language en_US.utf-8")
vim.g.mapleader = t("<Space>")

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"

vim.opt.shortmess:append("I")

vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
-- cursorcolumn is toggled by numbertoggle autocmd (lua/config/autocmd.lua) on focus/mode changes.
-- Setting here causes a redundant initial redraw before the autocmd takes over.
vim.opt.title = true
vim.opt.virtualedit = "onemore"
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.showmatch = true
vim.opt.showcmd = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.fenc = "utf-8"
local tabwidth = 2
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.wildmode = { list = "longest" }

vim.opt.undolevels = 1000
vim.opt.history = 1000
vim.opt.undofile = true

vim.opt.scrolloff = 4

vim.opt.list = true

vim.opt.listchars = {
  tab = "▸▹┊",
  trail = "▫",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

vim.opt.guicursor:append({ "t:blinkon0" })

vim.opt.pumblend = 10
vim.opt.laststatus = 3

vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- skip loading deprecated nvim-treesitter module to avoid startup warning message
vim.g.skip_ts_context_commentstring_module = true

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

vim.opt.winwidth = 30
vim.opt.winheight = 1
vim.opt.equalalways = false

vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
