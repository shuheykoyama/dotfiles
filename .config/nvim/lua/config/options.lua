-- edit
vim.cmd("language en_US.utf-8")
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.wrap = false
vim.g.mapleader = " "

-- search
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.breakindent = true

-- split
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"

-- scroll
vim.opt.scrolloff = 10

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- appearance
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.cursorline = true
vim.opt.mouse = "a"

-- sign
vim.opt.signcolumn = "yes"

-- cmdheight
vim.opt.cmdheight = 1
if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- skip loading deprecated nvim-treesitter module to avoid startup warning message
vim.g.skip_ts_context_commentstring_module = true

-- automatically saves undo history
vim.opt.undofile = true

-- others
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.laststatus = 3
vim.opt.shell = "zsh"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])
