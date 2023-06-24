local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.zsh,
    null_ls.builtins.formatting.clang_format, -- C/C++ formatter
    -- null_ls.builtins.diagnostics.checkstyle.with({
    --   extra_args = { "-c", "/google_checks.xml" }   -- a tool for checking Java source code
    -- }),
    null_ls.builtins.formatting.google_java_format, -- Java formatter according to Google Java Style
    null_ls.builtins.formatting.black,              -- Python formatter
    null_ls.builtins.diagnostics.flake8,            -- Python linter
    null_ls.builtins.formatting.isort,              -- Python import sort
    -- null_ls.builtins.diagnostics.mypy,              -- Python static type checker
    -- null_ls.builtins.formatting.ruff,               -- Python extremely fast linter
    -- null_ls.builtins.diagnostics.ruff,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end
}

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function()
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
  end,
  { nargs = 0 }
)
