return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        astro = { "biome" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "biome" },
        html = { "prettierd" },
        java = { "google-java-format" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        json = { "biome" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        -- php = { "pint" },
        python = { "ruff" },
        rust = { "rustfmt" },
        scss = { "prettierd" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
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
