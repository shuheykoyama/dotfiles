return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      swift = { "swiftlint" },
      dockerfile = { "hadolint" },
      -- TODO: textlint is not available in nvim-lint (no linter definition)
      -- markdown = { "textlint" },
      -- ["markdown.mdx"] = { "textlint" },
      -- fish: fish-lsp provides richer diagnostics (superset of fish --no-execute)
      markdown = { "markdownlint-cli2" },
      ["markdown.mdx"] = { "markdownlint-cli2" },
      yaml = { "yamllint" },
      -- actionlint: yaml.github compound filetype (set in autocmds.lua)
      ["yaml.github"] = { "actionlint" },
      -- yamllint: yaml.docker-compose compound filetype (set in autocmds.lua)
      ["yaml.docker-compose"] = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
