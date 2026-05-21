return {
  "chomosuke/term-edit.nvim",
  event = "TermOpen",
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
