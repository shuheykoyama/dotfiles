return {
  "selimacerbas/markdown-preview.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<cmd>MarkdownPreview<cr>",
      desc = "Markdown Preview",
    },
  },
  config = function()
    require("markdown_preview").setup({
      open_browser = true,
      debounce_ms = 300,
    })
  end,
}
