---@type vim.lsp.Config
return {
  cmd = { "oxfmt", "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "css",
    "scss",
    "less",
    "html",
    "vue",
    "json",
    "jsonc",
    "json5",
    "graphql",
    "handlebars",
    "markdown",
    "markdown.mdx",
    "yaml",
  },
  root_markers = {
    ".oxfmtrc.jsonc",
    ".oxfmtrc.json",
  },
}
