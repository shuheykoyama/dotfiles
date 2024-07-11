return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  config = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        astro = true,
        bash = true,
        c = true,
        cpp = true,
        css = true,
        html = true,
        java = true,
        javascript = true,
        javascriptreact = true,
        lua = true,
        markdown = true,
        python = true,
        rust = true,
        typescript = true,
        typescriptreact = true,
      },
    })
  end,
}
