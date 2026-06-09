return {
  "haringsrob/nvim_context_vt",
  event = "VeryLazy",
  config = function()
    require("nvim_context_vt").setup({
      enabled = true,
      disable_virtual_lines_ft = {
        "yaml",
        "python",
      },
    })
  end,
}
