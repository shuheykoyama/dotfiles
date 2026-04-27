return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    highlight = {
      groups = {
        -- Hardcoded kanagawa-dragon palette (sakuraPink + dragonBlack3 /
        -- oniViolet + dragonBlack2). Inlining hex values rather than pulling
        -- from `kanagawa.colors.setup()` avoids forcing kanagawa to load
        -- eagerly when running with another colorscheme, and removes the 1s
        -- defer_fn workaround that was used to delay that setup call.
        InclineNormal = { guibg = "#D27E99", guifg = "#181616" },
        InclineNormalNC = { guibg = "#1D1C19", guifg = "#957FB8" },
      },
    },
    window = { margin = { vertical = 0, horizontal = 1 } },
    hide = { cursorline = true },
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      if vim.bo[props.buf].modified then
        filename = "[+] " .. filename
      end
      local icon, hl = require("mini.icons").get("file", filename)
      return { { icon, group = hl }, { " " }, { filename } }
    end,
  },
}
