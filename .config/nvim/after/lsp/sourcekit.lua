---@type vim.lsp.Config
return {
  -- xcrun で動的解決（ハードコードより Xcode 更新に強い）
  cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
  filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
  -- buildServer.json (xcode-build-server) を最優先
  root_markers = {
    "buildServer.json",
    "*.xcodeproj",
    "*.xcworkspace",
    "compile_commands.json",
    "Package.swift",
    ".git",
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
}
-- SDK/target の設定はプロジェクト側の .sourcekit-lsp/config.json で管理:
-- {
--   "fallbackBuildSystem": {
--     "sdk": "/path/to/sdk",
--     "swiftCompilerFlags": ["-target", "x86_64-apple-ios18.2-simulator"]
--   }
-- }
-- または xcode-build-server を使用: brew install xcode-build-server
