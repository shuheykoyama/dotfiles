-- Execute current line via Snacks.debug.run (replaces nvim-luadev <localleader>l)
vim.keymap.set("n", "<localleader>l", function()
  Snacks.debug.run({ buf = 0 })
end, { buffer = true, desc = "Run lua line" })

-- Execute visual selection via Snacks.debug.run (replaces nvim-luadev <localleader>lr)
vim.keymap.set("x", "<localleader>r", function()
  Snacks.debug.run({ buf = 0 })
end, { buffer = true, desc = "Run lua selection" })

-- Execute operator motion (replaces nvim-luadev <localleader>lR)
vim.keymap.set("n", "<localleader>R", function()
  vim.o.operatorfunc = "v:lua.require'snacks.debug'.run"
  return "g@"
end, { buffer = true, expr = true, desc = "Run lua motion" })
