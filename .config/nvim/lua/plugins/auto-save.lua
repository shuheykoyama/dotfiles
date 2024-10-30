return {
  "Pocco81/auto-save.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("auto-save").setup({
      execution_message = {
        message = function() -- message to print on save
          return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0,
      },
    })
  end,
}
