return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        astro = { "prettierd" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        java = { "google-java-format" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        -- php = { "pint" },
        python = { "ruff" },
        rust = { "rustfmt" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        yaml = { "prettierd" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
