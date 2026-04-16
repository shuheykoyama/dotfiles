---@type vim.lsp.Config
return {
  single_file_support = false,
  workspace_required = true,
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            -- Enable cross-file TS analysis for .svelte <-> .ts (props, references, rename)
            name = "typescript-svelte-plugin",
            location = vim.fn.expand(
              "$HOME/.local/share/nvim/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin"
            ),
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
}
