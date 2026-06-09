---@type vim.lsp.Config
return {
  -- /usr/bin/sourcekit-lsp は Apple のシムで、起動ごとに有効ツールチェインへ
  -- 再ディスパッチする。xcrun の出力を config 評価時に 1 回キャプチャするより
  -- Xcode 更新に強く、起動経路から system 呼び出し (約 40-130ms) を排除できる。
  cmd = { "sourcekit-lsp" },
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
