require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
  -- vim.env.NVIM_COLORSCHEME = "lackluster"
  vim.env.NVIM_COLORSCHEME = "kanagawa-dragon"
end

local disabled_plugins = vim.tbl_map(function(b)
  return b.rtp
end, require("config.builtins"))

-- load plugins
lazy.setup({
  spec = {
    { import = "plugin" },
  },
  dev = {
    path = "~/ghq/github.com/shuheykoyama/",
  },
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  concurrency = 64,
  local_spec = false,
  pkg = { sources = { "lazy" } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = disabled_plugins,
    },
  },
})
