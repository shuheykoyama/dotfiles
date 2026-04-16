---@type vim.lsp.Config
return {
  workspace_required = true,
  -- svelte/vue/astro は experimental サポート（false positives あり）のため除外
  -- 各専用 LSP サーバーが診断を担当
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "typescript",
    "typescriptreact",
  },
}
