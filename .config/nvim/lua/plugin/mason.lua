return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  -- No `event` here: mason is a dependency of nvim-lspconfig, so it loads on
  -- the same BufReadPre wave and mason.setup() prepends its bin dir to PATH
  -- before any LSP starts. An explicit event would just double-trigger.
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  opts_extend = { "ensure_installed" },
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = " ",
        package_pending = "󱑤 ",
        package_uninstalled = "󰅙 ",
      },
    },
    ensure_installed = {
      -- formatters（ryoppippi 準拠）
      "biome",
      "fixjson",
      "prettier",
      "ruff",
      "stylua",
      -- formatters（ユーザー独自）
      "clang-format",
      "shfmt",
      "yamlfmt",
      -- sql
      "sqruff",
      -- linters（ryoppippi 準拠）
      "shellcheck",
      "markdownlint-cli2",
      "hadolint",
      "actionlint",
      "yamllint",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    -- Only mason.setup() must run synchronously here: it prepends mason's bin
    -- dir to PATH, which LSPs need before they start. The heavy registry
    -- refresh + ensure_installed install loop and mason-lspconfig setup are
    -- not needed for PATH, so defer them off the BufReadPre critical path.
    require("mason").setup(opts)

    vim.schedule(function()
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)

      local lsp_servers = require("core.lsp_servers")
      local ensure_installed = {}
      vim.list_extend(ensure_installed, lsp_servers.mason_common)
      vim.list_extend(ensure_installed, lsp_servers.mason_external)
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = false,
      })
    end)
  end,
}
