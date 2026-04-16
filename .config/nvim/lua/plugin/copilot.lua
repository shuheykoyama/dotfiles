return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "BufReadPost",
  build = ":Copilot auth",
  opts = {
    panel = {
      auto_refresh = true,
      layout = {
        position = "right",
      },
      keymap = {
        jump_prev = "_",
        jump_next = "-",
        accept = "<CR>",
        refresh = false,
        open = "<C-S-CR>",
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-s>",
        accept_word = false,
        accept_line = false,
        next = "<C-n>",
        prev = false,
        dismiss = "<C-l>",
      },
    },
    filetypes = {
      TeleScopePrompt = false,
      ["*"] = true,
    },
  },
}
