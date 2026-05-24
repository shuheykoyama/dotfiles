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

          -- Show the `~` filler character after the end of the buffer
          -- (kanagawa hides it by default by linking fg to theme.ui.bg).
          EndOfBuffer = { fg = theme.ui.nontext },

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

          -- Snacks: Dashboard
          SnacksDashboardHeader = { fg = theme.vcs.removed },
          SnacksDashboardFooter = { fg = theme.syn.comment },
          SnacksDashboardDesc = { fg = theme.syn.identifier },
          SnacksDashboardIcon = { fg = theme.ui.special },
          SnacksDashboardKey = { fg = theme.syn.special1 },
          SnacksDashboardSpecial = { fg = theme.syn.comment },
          SnacksDashboardDir = { fg = theme.syn.identifier },

          -- Snacks: Notifier
          SnacksNotifierBorderError = { link = "DiagnosticError" },
          SnacksNotifierBorderWarn = { link = "DiagnosticWarn" },
          SnacksNotifierBorderInfo = { link = "DiagnosticInfo" },
          SnacksNotifierBorderDebug = { link = "Debug" },
          SnacksNotifierBorderTrace = { link = "Comment" },
          SnacksNotifierIconError = { link = "DiagnosticError" },
          SnacksNotifierIconWarn = { link = "DiagnosticWarn" },
          SnacksNotifierIconInfo = { link = "DiagnosticInfo" },
          SnacksNotifierIconDebug = { link = "Debug" },
          SnacksNotifierIconTrace = { link = "Comment" },
          SnacksNotifierTitleError = { link = "DiagnosticError" },
          SnacksNotifierTitleWarn = { link = "DiagnosticWarn" },
          SnacksNotifierTitleInfo = { link = "DiagnosticInfo" },
          SnacksNotifierTitleDebug = { link = "Debug" },
          SnacksNotifierTitleTrace = { link = "Comment" },
          SnacksNotifierError = { link = "DiagnosticError" },
          SnacksNotifierWarn = { link = "DiagnosticWarn" },
          SnacksNotifierInfo = { link = "DiagnosticInfo" },
          SnacksNotifierDebug = { link = "Debug" },
          SnacksNotifierTrace = { link = "Comment" },

          -- Snacks: Profiler / Scratch
          SnacksProfilerIconInfo = { bg = theme.ui.bg_search, fg = theme.syn.fun },
          SnacksProfilerBadgeInfo = { bg = theme.ui.bg_visual, fg = theme.syn.fun },
          SnacksScratchKey = { link = "SnacksProfilerIconInfo" },
          SnacksScratchDesc = { link = "SnacksProfilerBadgeInfo" },
          SnacksProfilerIconTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
          SnacksProfilerBadgeTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },

          -- Snacks: Indent / Zen / Input
          SnacksIndent = { fg = theme.ui.bg_p2, nocombine = true },
          SnacksIndentScope = { fg = theme.ui.pmenu.bg, nocombine = true },
          SnacksZenIcon = { fg = theme.syn.statement },
          SnacksInputIcon = { fg = theme.ui.pmenu.bg },
          SnacksInputBorder = { fg = theme.syn.identifier },
          SnacksInputTitle = { fg = theme.syn.identifier },

          -- Snacks: Picker
          SnacksPickerInputBorder = { fg = theme.syn.constant },
          SnacksPickerInputTitle = { fg = theme.syn.constant },
          SnacksPickerBoxTitle = { fg = theme.syn.constant },
          SnacksPickerSelected = { fg = theme.syn.number },
          SnacksPickerToggle = { link = "SnacksProfilerBadgeInfo" },
          SnacksPickerPickWinCurrent = { fg = theme.ui.fg, bg = theme.syn.number, bold = true },
          SnacksPickerPickWin = { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true },
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
