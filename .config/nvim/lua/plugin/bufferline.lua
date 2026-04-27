return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      mode = "tabs",
      always_show_bufferline = false,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and " " .. diag.error .. " " or "")
          .. (diag.warning and " " .. diag.warning or "")
        return vim.trim(ret)
      end,
    },
  },
}
