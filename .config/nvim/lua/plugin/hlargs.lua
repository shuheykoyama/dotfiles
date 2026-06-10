return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  config = function()
    local hla = require("hlargs")
    hla.setup()
    vim.api.nvim_create_autocmd("colorscheme", {
      pattern = "*",
      callback = function()
        hla.enable()
      end,
    })
  end,
}
