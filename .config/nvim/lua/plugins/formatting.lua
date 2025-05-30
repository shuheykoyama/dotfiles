return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        astro = { "biome" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "biome" },
        html = { "prettierd" },
        java = { "google-java-format" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        json = { "biome" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        -- php = { "pint" },
        python = { "ruff" },
        rust = { "rustfmt" },
        scss = { "prettierd" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        yaml = { "prettierd" },
      },
      -- format_on_save = {
      --   lsp_fallback = true,
      --   async = false,
      --   timeout_ms = 3000,
      -- },
    })

    local text_changed = false

    vim.api.nvim_create_autocmd("TextChanged", {
      buffer = 0,
      callback = function()
        text_changed = true
      end,
      once = true,
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      local formatters = conform.list_formatters()
      local fmt_names = {}

      if not vim.tbl_isempty(formatters) then
        fmt_names = vim.tbl_map(function(f)
          return f.name
        end, formatters)
      elseif conform.will_fallback_lsp() then
        fmt_names = { "lsp" }
      else
        return
      end

      local fmt_info = table.concat(fmt_names, "/")

      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })

      if text_changed then
        vim.notify("Conform: formatted with " .. fmt_info, "")
      end
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
