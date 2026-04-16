return {
  "chomosuke/term-edit.nvim",
  event = "TermEnter",
  version = "1.*",
  opts = {
    prompt_end = "❯ ",
    mapping = {
      n = {
        ["<C-i>"] = false,
      },
    },
  },
  config = true,
}
