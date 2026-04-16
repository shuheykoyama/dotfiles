local function diagnostic_formatter(diagnostic)
  return string.format("[%s] %s (%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

return {
  ---@type OnAttachCallback
  on_attach = function(client, bufnr)
    vim.diagnostic.config({
      underline = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
      },
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 4,
        prefix = "●",
        format = function(d)
          return string.format("[%s] %s", d.source, d.message)
        end,
      },
      float = { format = diagnostic_formatter, border = "rounded" },
    })
  end,
}
