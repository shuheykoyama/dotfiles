return {
  "SmiteshP/nvim-navic",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.g.navic_silence = true
  end,
  opts = function()
    return {
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = true,
      separator = "  ",
      depth_limit = 3,
      depth_limit_indicator = "..",
      safe_output = true,
      lazy_update_context = false,
      click = false,
      format_text = function(text)
        return text
      end,
    }
  end,
}
