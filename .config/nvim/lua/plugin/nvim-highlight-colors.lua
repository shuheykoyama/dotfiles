---@type LazySpec
return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    render = "background",
    enable_tailwind = true,
    enable_ansi = true,
  },
}
