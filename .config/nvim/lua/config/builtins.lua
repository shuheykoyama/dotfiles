-- Canonical list of Neovim builtin runtime plugins to disable.
-- Source of truth for both vim.g.loaded_* guards (base.lua) and
-- lazy.nvim performance.rtp.disabled_plugins (pack.lua).
return {
  -- archive handlers
  { rtp = "gzip",         guard = "loaded_gzip" },
  { rtp = "tarPlugin",    guard = "loaded_tarPlugin" },
  { rtp = "zipPlugin",    guard = "loaded_zipPlugin" },
  -- matching/paren (covered by vim-matchup)
  { rtp = "matchit",      guard = "loaded_matchit" },
  { rtp = "matchparen",   guard = "loaded_matchparen" },
  -- net/remote (netrw covered by oil.nvim; net kept enabled for :e https://... URLs)
  { rtp = "netrwPlugin",  guard = "loaded_netrwPlugin" },
  -- misc
  { rtp = "rplugin",      guard = "loaded_remote_plugins" },
  { rtp = "spellfile",    guard = "loaded_spellfile_plugin" },
  { rtp = "tutor",        guard = "loaded_tutor_mode_plugin" },
  -- shada file editor (NOT shada option persistence)
  { rtp = "shada",        guard = "loaded_shada_plugin" },
}
