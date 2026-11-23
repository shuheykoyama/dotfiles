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

---@param path string
---@return string?
local function file_mtime(path)
  local stat = vim.uv.fs_stat(path)
  return stat and (stat.mtime.sec .. "." .. stat.mtime.nsec) or nil
end

-- Remember the mtime when nvim reads or writes a file, so that a change made by
-- another tool can be noticed before the next auto-save.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "FileChangedShellPost" }, {
  group = auto_save_group,
  callback = function(args)
    vim.b[args.buf].autosave_mtime = file_mtime(vim.api.nvim_buf_get_name(args.buf))
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = auto_save_group,
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local bo = vim.bo[buf]
    local filename = vim.api.nvim_buf_get_name(buf)
    if
      bo.buftype ~= ""
      or bo.filetype == ""
      or filename == ""
      or not bo.modified
      or not bo.modifiable
      or bo.readonly
    then
      return
    end

    local relpath = vim.fn.fnamemodify(filename, ":.")
    -- `:write` stops to ask "Do you really want to write to it (y/n)?" when the
    -- file changed on disk, so skip instead of overwriting the other change.
    local recorded = vim.b[buf].autosave_mtime
    if recorded and file_mtime(filename) ~= recorded then
      vim.notify("AutoSave: skipped " .. relpath .. " (changed on disk)", vim.log.levels.WARN)
      return
    end

    vim.cmd("silent! write")
    -- BufWritePost does not fire for a write made inside an autocmd (not nested).
    vim.b[buf].autosave_mtime = file_mtime(filename)
    if bo.modified then
      vim.notify("AutoSave: failed to save " .. relpath, vim.log.levels.WARN)
    else
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
