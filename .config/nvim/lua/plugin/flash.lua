---@type LazySpec
return {
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {
    modes = {
      -- char mode enabled: replaces quick-scope (f/t highlights) and mini.jump (enhanced f/F)
      search = { enabled = false },
      treesitter = { enabled = false },
    },
  },
  keys = {
    {
      "<CR>",
      mode = { "n", "x", "o", "v" },
      function()
        require("flash").jump({ label = { before = true, after = false } })
      end,
      desc = "Flash",
    },
  },
}
