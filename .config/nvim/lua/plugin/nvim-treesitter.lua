return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    { "David-Kunz/treesitter-unit" },
  },
  config = function()
    require("nvim-treesitter").setup({
      auto_install = false,
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) <= 50000 then
          pcall(vim.treesitter.start, args.buf)
        end
      end,
    })
  end,
}
