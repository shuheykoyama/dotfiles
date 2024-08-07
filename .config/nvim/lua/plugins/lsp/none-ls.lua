return {
  "nvimtools/none-ls.nvim", -- configure formatters & linters
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")

    mason_null_ls.setup({
      ensure_installed = {
        "prettierd", -- prettier formatter
        "stylua", -- lua formatter
        -- "black", -- python formatter
        -- "isort", -- python formatter
        -- "flake8", -- python linter
        "eslint_d", -- js linter
        "shfmt",
        "shellcheck",
        "clang-format",
        "google-java-format",
        "checkstyle",
        "selene",
        "markdownlint",
        -- "pint",
        -- "phpstan",
        -- "rustfmt",
        "ruff",
      },
    })

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- to setup format on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- configure null_ls
    null_ls.setup({
      diagnostics_format = "#{m} (#{s}: #{c})",
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      -- setup formatters & linters
      sources = {
        --  to disable file types use
        --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
        formatting.prettierd.with({ -- js/ts formatter
          extra_filetypes = { "astro" },
        }),
        formatting.stylua, -- lua formatter
        -- formatting.isort,
        -- formatting.black,
        formatting.shfmt,
        formatting.clang_format,
        -- formatting.clang_format.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ ".clang_format" })
        --   end,
        -- }),
        formatting.google_java_format,
        -- formatting.markdownlint,
        -- formatting.pint.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ "pint.json" })
        --   end,
        -- }),
        require("none-ls.formatting.ruff"),
        -- formatting.rustfmt,
        diagnostics.checkstyle,
        diagnostics.selene,
        diagnostics.markdownlint,
        -- diagnostics.phpstan,
        -- diagnostics.flake8,
        require("none-ls.diagnostics.eslint_d").with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.yml", ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          end,
        }),
        require("none-ls.diagnostics.ruff"),
      },
      -- configure format on save
      on_attach = function(current_client, bufnr)
        if current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
