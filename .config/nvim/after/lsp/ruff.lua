---@type vim.lsp.Config
return {
  -- Prefer the project's own ruff (.venv/bin/ruff, e.g. a uv dev dependency) so the
  -- LSP matches the version conform.nvim formats with; otherwise use the Mason one.
  cmd = function(dispatchers, config)
    local cmd = "ruff"
    for _, venv in
      ipairs(vim.fs.find(".venv", { upward = true, path = config.root_dir or vim.uv.cwd(), limit = math.huge }))
    do
      local project_ruff = venv .. "/bin/ruff"
      if vim.fn.executable(project_ruff) == 1 then
        cmd = project_ruff
        break
      end
    end
    return vim.lsp.rpc.start({ cmd, "server" }, dispatchers)
  end,
  on_attach = function(client)
    -- hover は pyrefly に任せる
    client.server_capabilities.hoverProvider = false
    -- フォーマットは conform.nvim（ruff format）に任せる
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
