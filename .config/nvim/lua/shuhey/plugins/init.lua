local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

if #vim.api.nvim_get_runtime_file("lua/shuhey/plugins/local.lua", false) > 0 then
  require("shuhey.plugins.local")
end

require("lazy").setup({
  spec = {
    { import = "shuhey.plugins.ui" },
    { import = "shuhey.plugins.treesitter" },
    { import = "shuhey.plugins.editor" },
    { import = "shuhey.plugins.lsp" },
    { import = "shuhey.plugins.util" },
    { import = "shuhey.plugins.keymaps" },
  },
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "solarized-osaka" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  local_spec = false,
  pkg = { sources = { "lazy" } },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "tutor", "rplugin", "spellfile", "shada" },
    },
  },
})
