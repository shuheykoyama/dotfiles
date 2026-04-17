---@type LazySpec
return {
  "jmbuhr/otter.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown", "html" },
  opts = {
    buffers = {
      set_filetype = true,
      write_to_disk = false,
    },
    handle_leading_whitespace = true,
  },
  config = function(_, opts)
    require("otter").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "html" },
      callback = function()
        require("otter").activate()
      end,
      desc = "Auto-activate otter for embedded code LSP",
    })
  end,
}
