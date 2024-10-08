return {
  "b0o/incline.nvim",
  event = "BufRead",
  priority = 1200,
  config = function()
    local colors = require("tokyonight.colors.storm")
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = colors.magenta2, guifg = "#000000" },
          InclineNormalNC = { guibg = colors.terminal_black, guifg = "#000000" },
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

        local icon, color = require("nvim-web-devicons").get_icon_color(filename)
        return { { icon, guifg = color }, { " " }, { filename } }
      end,
    })
  end,
}
