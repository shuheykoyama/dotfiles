---@type LazySpec
return {
  "suliatis/Jumppack.nvim",
  keys = {
    {
      "g<C-o>",
      function() require("Jumppack").start({ offset = -1 }) end,
      desc = "Jumppack backward",
    },
    {
      "g<C-i>",
      function() require("Jumppack").start({ offset = 1 }) end,
      desc = "Jumppack forward",
    },
  },
  opts = {
    options = { global_mappings = false },
  },
}
