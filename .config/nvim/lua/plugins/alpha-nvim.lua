return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  cond = function()
    return vim.fn.argc() == 0
  end,
  dependencies = { "echasnovski/mini.icons" },
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "██████╗ ███████╗    ██╗      █████╗ ███████╗██╗   ██╗",
      "██╔══██╗██╔════╝    ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝",
      "██████╔╝█████╗      ██║     ███████║  ███╔╝  ╚████╔╝ ",
      "██╔══██╗██╔══╝      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ",
      "██████╔╝███████╗    ███████╗██║  ██║███████╗   ██║   ",
      "╚═════╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ",
      "",
      "",
      "",
      "",
      "",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC e", "  > Toggle file explorer", "<cmd>Neotree<CR>"),
      dashboard.button(";f", "󰱼  > Find File"),
      dashboard.button(";r", "  > Find Word"),
      -- dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
