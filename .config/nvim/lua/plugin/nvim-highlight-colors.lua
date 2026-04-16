---@type LazySpec
return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost" },
  opts = {
    render = "virtual",
    enable_tailwind = true,
  },
}
