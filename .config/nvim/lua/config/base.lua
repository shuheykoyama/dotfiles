-- Apply canonical builtin-disable guards (single source of truth in config/builtins.lua).
for _, b in ipairs(require("config.builtins")) do
  vim.g[b.guard] = 1
end

-- Other builtins NOT in the canonical table (not scanned as runtime/plugin on 0.12,
-- kept for defense-in-depth on legacy paths).
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zip = 1
-- :Man is used via MANPAGER="nvim +Man!" in fish config; keep it enabled.

vim.g.loaded_fzf = 1
vim.g.loaded_gtags = 1
vim.g.loaded_gtags_cscope = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_pythonx_provider = 0
vim.g.load_black = 1

vim.g.loaded_ruby_provider = 0

-- vim.g.did_load_ftplugin = 1
vim.g.did_indent_on = 1
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1

-- Add Nix-provided tree-sitter grammars to runtimepath
local treesitter_grammars = vim.env.TREESITTER_GRAMMARS
if treesitter_grammars then
  vim.opt.runtimepath:append(treesitter_grammars)
end
