---@type vim.lsp.Config
return {
  -- Use yaml.github compound filetype to prevent dual-attach with yamlls.
  -- yamlls does not list yaml.github in its default filetypes,
  -- so gh_actions_ls gets exclusive attachment on workflow files.
  filetypes = { "yaml.github" },
}
