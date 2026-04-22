return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  event = { "BufReadPre", "BufNewFile" },
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
    require("mason").setup(opts)

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

    vim.schedule(function()
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
