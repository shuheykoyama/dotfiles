return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
      },
      panel = { enabled = true },
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

    vim.keymap.set("i", "<Tab>", function()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, {
      desc = "Accept copilot suggestion",
    })
  end,
}
