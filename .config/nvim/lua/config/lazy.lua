local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lsp" },
  },
  defaults = {
    lazy = true,
  },
  install = {
    -- colorscheme = { "catppuccin-mocha" },
    colorscheme = { "tokyonight-night" },
    -- colorscheme = { "solarized-osaka" },
    -- colorscheme = { "github_dark" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})
