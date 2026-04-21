---@type LazySpec
return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    render = "virtual",
    enable_tailwind = true,
  },
}
