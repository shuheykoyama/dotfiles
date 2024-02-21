return {
  "b0o/incline.nvim",
  event = "BufRead",
  priority = 1200,
  config = function()
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = "#f38ba8", guifg = "#1e1e2e" },
          InclineNormalNC = { guibg = "#f2cdcd", guifg = "#1e1e2e" },
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
