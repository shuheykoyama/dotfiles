-- open config
vim.api.nvim_create_user_command("Config", function()
  vim.cmd.e(vim.fn.stdpath("config"))
end, { nargs = 0 })

vim.api.nvim_create_user_command("EncodingReload", "execute 'e ++enc=<args>'", { force = true, nargs = 1 })

-- count word
vim.api.nvim_create_user_command("CountWord", function()
  local input = vim.fn.input("", "':%s/\\<<C-r><C-w>\\>/&/gn'")
  vim.cmd(input)
  vim.fn.histadd("cmd", input)
end, { force = true })

vim.api.nvim_create_user_command("ToggleStatusBar", function()
  if vim.o.laststatus == 3 then
    vim.opt.laststatus = 0
  else
    vim.opt.laststatus = 3
  end
end, { nargs = 0, force = true })

-- sort startuptime
vim.api.nvim_create_user_command("SortStartupTime", "%!sort -k2nr", { force = true })

vim.api.nvim_create_user_command("ToggleCursorline", function()
  vim.wo.cursorline = not vim.wo.cursorline
  vim.wo.cursorcolumn = not vim.wo.cursorcolumn
end, { nargs = 0, force = true })

vim.api.nvim_create_user_command("CopyPath", function(opts)
  local path
  if opts.bang then
    path = vim.fn.expand("%:.")
  else
    path = vim.fn.expand("%:p")
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { nargs = 0, bang = true, force = true })

-- Capture ex command output into a scratch buffer (equivalent to tyru/capture.vim)
vim.api.nvim_create_user_command("Capture", function(opts)
  local cmd = opts.args
  local lines

  -- Shell commands (!prefix) use vim.fn.systemlist since nvim_exec2 cannot capture them
  if vim.startswith(cmd, "!") then
    lines = vim.fn.systemlist(cmd:sub(2))
  else
    local ok, result = pcall(vim.api.nvim_exec2, cmd, { output = true })
    if not ok or not result.output or result.output == "" then
      vim.notify("Capture: no output", vim.log.levels.WARN)
      return
    end
    lines = vim.split(result.output, "\n")
  end

  -- Open a scratch buffer in a bottom split
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(0, buf)
end, { nargs = "+", complete = "command", force = true })

vim.api.nvim_create_user_command("QuickLook", function()
  -- get current buffer absolute path
  local path = vim.fn.expand("%:p")

  require("core.utils").open_file_with_quicklook(path)
end, { nargs = 0, force = true })
