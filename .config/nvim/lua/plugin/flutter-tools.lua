---@type LazySpec
return {
  "nvim-flutter/flutter-tools.nvim",
  ft = "dart",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- flutter is on $PATH via mise (fish `mise activate`), so flutter-tools
    -- auto-detects it -- no flutter_lookup_cmd needed. snacks.picker provides
    -- vim.ui.select for the device/emulator pickers, so dressing.nvim is not
    -- needed either.
    lsp = {
      -- dartls is started by flutter-tools (do NOT add it to vim.lsp.enable).
      -- The global LspAttach autocmd in nvim-lspconfig/init.lua applies our
      -- shared LSP keymaps to it. vim.lsp.config("*") does not reach this
      -- instance, so feed blink.cmp capabilities in here explicitly.
      capabilities = function(config)
        local ok, blink = pcall(require, "blink.cmp")
        return ok and vim.tbl_deep_extend("force", config, blink.get_lsp_capabilities()) or config
      end,
      settings = {
        completeFunctionCalls = true,    -- insert () and required params on completion
        showTodos = true,                -- surface TODO comments as diagnostics
        updateImportsOnRename = true,    -- fix imports when a file is moved/renamed
        renameFilesWithClasses = "prompt", -- rename the file when a class is renamed (asks first)
        enableSnippets = true,
        -- lineLength / analysisExcludedFolders are intentionally left to the
        -- project's analysis_options.yaml rather than pinned here, and SDK /
        -- dependency analysis is kept on for go-to-definition.
      },
    },
    -- widget_guides off to avoid overlapping with snacks.indent guides.
    widget_guides = { enabled = false },
  },
  keys = {
    { "<leader>Fr", "<cmd>FlutterRun<cr>",           desc = "Flutter Run",         ft = "dart" },
    { "<leader>FR", "<cmd>FlutterRestart<cr>",       desc = "Flutter Restart",     ft = "dart" },
    { "<leader>Fq", "<cmd>FlutterQuit<cr>",          desc = "Flutter Quit",        ft = "dart" },
    { "<leader>Fd", "<cmd>FlutterDevices<cr>",       desc = "Flutter Devices",     ft = "dart" },
    { "<leader>Fe", "<cmd>FlutterEmulators<cr>",     desc = "Flutter Emulators",   ft = "dart" },
    { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline",     ft = "dart" },
    { "<leader>FD", "<cmd>FlutterDevTools<cr>",      desc = "Flutter DevTools",    ft = "dart" },
  },
}
