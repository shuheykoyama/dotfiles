-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  pattern = "*",
  command = "set nopaste",
})

-- Highlight the current line on only the active buffer
local cursorline_group = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = cursorline_group,
  pattern = "*",
  command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = cursorline_group,
  pattern = "*",
  command = "setlocal nocursorline",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Custom filetypes
vim.filetype.add({
  extension = {
    mjml = "html",
  },
})

-- Additional filetypes (mdx is registered in plugins/treesitter.lua)
vim.filetype.add({
  extension = {
    jax = "help",
    kbd = "lisp",
    log = "log",
    LOG = "log",
  },
  filename = {
    [".envrc"] = "sh",
    ["Podfile"] = "ruby",
  },
  pattern = {
    -- git
    [".*/%.git/.*%.conf"] = "gitconfig",
    [".*/git/config"] = "gitconfig",
    [".*/git/.*%.conf"] = "gitconfig",
    [".*/%.git/ignore"] = "gitignore",
    [".*/git/ignore"] = "gitignore",
    -- ssh
    [".*/ssh/.*%.conf"] = "sshconfig",
    -- env
    [".*/env.development"] = "sh",
    [".*/env.production"] = "sh",
    [".*/env.staging"] = "sh",
    [".*/env.local"] = "sh",
    -- docker & compose
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["compose%.ya?ml"] = "yaml.docker-compose",
    -- log (generic log files: *_log / *_LOG; *.log / *.LOG handled by extension)
    [".*_log"] = "log",
    [".*_LOG"] = "log",
  },
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

-- Formatting on save is opt-in per buffer: :ToggleFormatter turns it on.
-- Only an unset value is defaulted, so the toggle is never reset on re-entry.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufEnter" }, {
  group = augroup,
  callback = function(args)
    if vim.b[args.buf].disable_autoformat == nil then
      vim.b[args.buf].disable_autoformat = true
    end
  end,
})
