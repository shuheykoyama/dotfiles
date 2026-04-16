return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  config = function()
    local colors = require("kanagawa.colors").setup({ theme = "dragon" })
    local theme = colors.theme
    local palette = colors.palette
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = palette.sakuraPink, guifg = theme.ui.bg },
          InclineNormalNC = { guifg = palette.oniViolet, guibg = theme.ui.bg_m1 },
        },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end

        local icon, hl = require("mini.icons").get("file", filename)
        return { { icon, group = hl }, { " " }, { filename } }
      end,
    })
  end,
}
