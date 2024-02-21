return {
  {
    "echasnovski/mini.animate",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    opts = {
      symbol = "▏",
      options = { try_as_border = true },
    },
  },
}
