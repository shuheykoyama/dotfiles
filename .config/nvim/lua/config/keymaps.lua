local keymap = vim.keymap

-- hjkl
keymap.set({ "n", "x" }, "j", function()
  if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
    -- @see https://eiji.page/blog/neovim-remeber-jump-jk/
    return "m'" .. vim.v.count .. "j"
  end
  return "gj"
end, { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", function()
  if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
    -- @see https://eiji.page/blog/neovim-remeber-jump-jk/
    return "m'" .. vim.v.count .. "k"
  end
  return "gk"
end, { expr = true, silent = true })

-- disable keys
-- keymap.set("n", "H", "<Nop>")
-- keymap.set("n", "J", "<Nop>")
keymap.set("n", "K", "<Nop>")
-- keymap.set("n", "L", "<Nop>")
keymap.set({ "n", "v" }, "s", "<Nop>")
keymap.set({ "n", "v" }, "S", "<Nop>")

keymap.set("n", "gh", "<Nop>")
keymap.set("n", "gj", "<Nop>")
keymap.set("n", "gk", "<Nop>")
keymap.set("n", "gl", "<Nop>")

-- remap H M L
keymap.set("n", "gH", "H")
keymap.set("n", "gM", "M")
keymap.set("n", "gL", "L")

-- split window
keymap.set("n", "ss", function()
  vim.cmd("split")
  vim.cmd("wincmd =")
end, { noremap = true, silent = true })
keymap.set("n", "sv", function()
  vim.cmd("vsplit")
  vim.cmd("wincmd =")
end, { noremap = true, silent = true })

-- move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sl", "<C-w>l")


-- tab management
keymap.set("n", "<tab>", "<cmd>tabnext<cr>", { silent = true })
keymap.set("n", "<s-tab>", "<cmd>tabprevious<cr>", { silent = true })
keymap.set("n", "th", "<cmd>tabfirst<cr>", { silent = true })
keymap.set("n", "tj", "<cmd>tabprevious<cr>", { silent = true })
keymap.set("n", "tk", "<cmd>tabnext<cr>", { silent = true })
keymap.set("n", "tl", "<cmd>tablast<cr>", { silent = true })
keymap.set("n", "tt", "<cmd>tabe .<cr>", { silent = true })
keymap.set("n", "tq", "<cmd>tabclose<cr>", { silent = true })
keymap.set("n", "te", "<cmd>tabedit<cr>", { silent = true })

-- jj -> <ESC>
-- keymap.set("i", "jj", "<Esc>")

-- arrow key prevent stopping undo block
-- keymap.set("i", "<Left>", "<C-g>u<Left>")
-- keymap.set("i", "<Right>", "<C-g>u<Right>")

-- terminal mode
keymap.set("t", "<C-k>", [[<C-\><C-n>]])

-- command mode
--- Emacs style from yutkat
keymap.set("c", "<C-a>", "<Home>", { silent = false })
keymap.set("c", "<C-e>", "<End>", { silent = false })
keymap.set("c", "<C-f>", "<right>", { silent = false })
keymap.set("c", "<C-b>", "<left>", { silent = false })
keymap.set("c", "<C-d>", "<DEL>", { silent = false })

-- toggle 0 made by ycino
keymap.set("n", "0", function()
  return string.match((vim.fn.getline(".") --[[@as string]]):sub(0, vim.fn.col(".") - 1), "^%s+$") and "0" or "^"
end, { expr = true, silent = true })

-- Automatically indent with i and A made by ycino
keymap.set("n", "i", function()
  return vim.fn.len(vim.fn.getline(".")) ~= 0 and "i" or '"_cc'
end, { expr = true, silent = true })
keymap.set("n", "A", function()
  return vim.fn.len(vim.fn.getline(".")) ~= 0 and "A" or '"_cc'
end, { expr = true, silent = true })

-- custom
-- keymap.set("n", "<leader>ss", vim.cmd.ToggleStatusBar)

-- tips {{
-- keymap.set({ "n", "v" }, "gy", '"+y') -- yank to clipboard
keymap.set({ "n", "v" }, "x", '"_x') -- delete without yank
keymap.set({ "n", "v" }, "X", '"_d$') -- delete to end of line without yank
keymap.set("n", "<C-a>", "gg<S-v>G") -- select all
keymap.set({ "n", "v" }, "<leader>x", vim.cmd.cclose)
keymap.set("n", "gq", "<cmd>nohlsearch<cr><esc>")
keymap.set("n", "U", "<C-r>") -- redo by U
keymap.set({ "n", "v" }, "M", "%") -- jump to matching bracket by M (also in visual mode)
keymap.set("x", "p", "P") -- {visual}p to put without yank to unnamed register https://github.com/Shougo/shougo-s-github/blob/21a3f500cdc2b37c8d184edbf640d9e17458358a/vim/rc/mappings.rc.vim#L190-L191
keymap.set("x", "y", "mzy`z") -- keep cursor position after yank in visual mode
keymap.set("i", "<C-k>", function() -- capitalize word
  local line = vim.fn.getline(".")
  local col = vim.fn.getpos(".")[3]
  local substring = line:sub(1, col - 1)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return "<C-w>" .. result:upper()
end, { expr = true })
-- }}

-- replace
keymap.set("x", "S", 'y:%s/<C-r><C-r>"//g<Left><Left>')
keymap.set("n", "S", 'yiw:%s/<C-r><C-r>"//g<Left><Left>')

-- indent in visual mode
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- tips from monaqa san: https://zenn.dev/vim_jp/articles/2024-06-05-vim-middle-class-features
for _, quote in ipairs({ '"', "'", "`" }) do
  keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end

keymap.set("", "<c-i>", "<c-i>")
keymap.set("n", "<C-m>", "<C-i>") -- distinguish <C-m> from <C-i> in terminal
keymap.set("n", "g<leader>", "<cmd>QuickLook<cr>")
keymap.set("n", "<leader>L", function()
  local path = vim.fn.expand("%:p") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path to clipboard" })

-- literal search: \V (very nomagic) prefix so special chars don't need escaping
keymap.set("n", "g/", "/\\V")
keymap.set("n", "g?", "?\\V")

-- stay-star: search word under cursor without moving cursor (replaces vim-asterisk z*)
-- sets @/ register + search direction so n/N work correctly after
local function stay_star(whole_word, forward)
  local word = vim.fn.expand("<cword>")
  local pattern = whole_word and ("\\<" .. word .. "\\>") or word
  vim.fn.setreg("/", pattern)
  vim.fn.histadd("search", pattern)
  vim.v.searchforward = forward and 1 or 0
  vim.cmd("set hlsearch")
end
keymap.set("n", "*",  function() stay_star(true,  true)  end)
keymap.set("n", "#",  function() stay_star(true,  false) end)
keymap.set("n", "g*", function() stay_star(false, true)  end)
keymap.set("n", "g#", function() stay_star(false, false) end)
