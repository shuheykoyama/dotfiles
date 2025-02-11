return {
  "b0o/incline.nvim",
  event = { "FocusLost", "CursorHold" },
  config = function()
    -- local colors = require("tokyonight.colors.night")
    local colors = require("solarized-osaka.colors").setup()
    -- local colors = require("github-theme.palette").load("github_dark")
    require("incline").setup({
      highlight = {
        -- groups = {
        --   InclineNormal = { guibg = colors.magenta2, guifg = "#000000" },
        --   InclineNormalNC = { guibg = colors.terminal_black, guifg = "#000000" },
        -- },
        groups = {
          InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
          InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
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
