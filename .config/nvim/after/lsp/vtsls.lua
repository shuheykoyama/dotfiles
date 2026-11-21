---@type vim.lsp.Config
return {
  on_attach = function(client)
    if client and client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider.range = false
    end
  end,
  settings = {
    complete_function_calls = true,
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
          {
            -- Enable cross-file TS analysis for .astro <-> .ts (props, references, rename)
            name = "@astrojs/ts-plugin",
            location = vim.fn.expand(
              "$HOME/.local/share/nvim/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin"
            ),
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        useAliasesForRenames = false,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}
