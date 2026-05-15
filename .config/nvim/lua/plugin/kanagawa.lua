local TRANSPARENT = true

local isKanagawa = function()
  return vim.startswith(vim.env.NVIM_COLORSCHEME, "kanagawa")
end

return {
  "rebelot/kanagawa.nvim",
  -- Load kanagawa on UIEnter (after Neovim's UI is attached) to keep the
  -- colorscheme off the startup-time critical path. lazy.nvim registers its
  -- UIEnter autocmd before snacks', so kanagawa's colorscheme is applied
  -- synchronously within UIEnter handling and snacks.dashboard still renders
  -- with theme highlights. A brief default-color flash in the Neovim TUI
  -- initial-draw phase is accepted as a trade-off for faster startup.
  priority = isKanagawa() and 1000 or 50,
  event = isKanagawa() and { "UiEnter" } or { "ColorScheme" },
  build = ":KanagawaCompile",
  opts = function()
    return {
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- LineNr = { bg = "NONE" },
          -- SignColumn = { bg = "NONE" },
          -- FoldColumn = { bg = "NONE" },

          SatelliteBar = { bg = theme.ui.special },

          RainbowDelimiterRed = { fg = theme.syn.preproc },
          RainbowDelimiterYellow = { fg = theme.syn.special2 },
          RainbowDelimiterBlue = { fg = theme.syn.fun },
          RainbowDelimiterOrange = { fg = theme.syn.number },
          RainbowDelimiterGreen = { fg = theme.syn.string },
          RainbowDelimiterViolet = { fg = theme.syn.statement },
          RainbowDelimiterCyan = { fg = theme.syn.type },

          CopilotAnnotation = { bg = theme.ui.bg_p1, italic = true },
          CopilotSuggestion = { bg = theme.ui.bg_p2, italic = true },

          NoiceVirtualText = { bg = theme.ui.bg_search },
          NoiceCmdlinePopup = { bg = theme.ui.float.bg },
          NoiceCmdlinePopupBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.float.bg },
        }
      end,
      transparent = TRANSPARENT,
      compile = true,
    }
  end,
  config = function(_, opts)
    local k = require("kanagawa")
    k.setup(opts)
    if isKanagawa() then
      vim.cmd.colorscheme(vim.env.NVIM_COLORSCHEME)
    end
  end,
}
