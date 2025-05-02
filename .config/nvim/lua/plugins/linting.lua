return {
  "mfussenegger/nvim-lint",
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      astro = { "biomejs" },
      bash = { "shellcheck" },
      css = { "biomejs" },
      html = { "prettierd" },
      java = { "checkstyle" },
      javascript = { "biomejs" },
      javascriptreact = { "biomejs" },
      json = { "biomejs" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      -- php = { "phpstan" },
      python = { "ruff" },
      scss = { "biomejs" },
      typescript = { "biomejs" },
      typescriptreact = { "biomejs" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
