return {
  "mfussenegger/nvim-lint",
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      astro = { "eslint_d" },
      bash = { "shellcheck" },
      java = { "checkstyle" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      -- php = { "phpstan" },
      python = { "ruff" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
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
