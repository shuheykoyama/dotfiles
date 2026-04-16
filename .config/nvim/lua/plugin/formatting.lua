return {
  "stevearc/conform.nvim",
  lazy = true,
  keys = {
    {
      "<leader>cf",
      function()
        local conform = require("conform")
        local bufnr = vim.api.nvim_get_current_buf()
        local formatters, will_fallback = conform.list_formatters_to_run(bufnr)
        local fmt_names = {}

        if not vim.tbl_isempty(formatters) then
          fmt_names = vim.tbl_map(function(f)
            return f.name
          end, formatters)
        elseif will_fallback then
          fmt_names = { "lsp" }
        else
          return
        end

        local fmt_info = table.concat(fmt_names, "/")

        conform.format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })

        vim.notify("Conform: formatted with " .. fmt_info, "")
      end,
      desc = "Format file or range (in visual mode)",
      mode = { "n", "v" },
    },
  },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- prettier (require-marker: .prettierrc*) → lsp_fallback
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        ["javascript.jsx"] = { "prettier" },
        typescriptreact = { "prettier" },
        ["typescript.tsx"] = { "prettier" },
        html = { "prettier" },
        svelte = { "prettier" },
        vue = { "prettier" },
        astro = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        yaml = { "prettier", "yamlfmt", stop_after_first = true },
        ["yaml.github"] = { "prettier", "yamlfmt", stop_after_first = true },
        jsonc = { "prettier" },
        json5 = { "prettier" },
        -- json: fixjson（常時）→ prettier（require-marker）
        json = { "fixjson", "prettier" },
        -- lua: stylua（require-marker: stylua.toml）
        lua = { "stylua" },
        -- python: uv run ruff format（ryoppippi 準拠）
        python = { "ruff_format" },
        -- markdown: .prettierrc* なしでも常にフォーマット（condition で制御済み）
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        -- 非 LSP ツール（ryoppippi に未設定だがユーザー継続）
        swift = { "swiftformat" },
        fish = { "fish_indent" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- sql: sqruff（スタイルフォーマット）
        sql = { "sqruff" },
      },
      formatters = {
        prettier = {
          condition = function(_, ctx)
            local ft = vim.bo[ctx.buf].filetype
            -- markdown は .prettierrc* なしでも常にフォーマット（デフォルト設定が合理的）
            if ft == "markdown" or ft == "markdown.mdx" then
              return vim.fn.executable("prettier") == 1
            end
            local has_config = vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.mjs",
              ".prettierrc.cjs",
              ".prettierrc.toml",
            }, { upward = true, path = ctx.dirname })[1] ~= nil
            if not has_config then
              return false
            end
            -- バイナリが存在するか確認（node_modules またはグローバル）
            local has_bin = vim.fs.find(
              "node_modules/.bin/prettier",
              { upward = true, path = ctx.dirname }
            )[1] ~= nil or vim.fn.executable("prettier") == 1
            return has_bin
          end,
        },
        stylua = {
          condition = function(_, ctx)
            return vim.fs.find(
              { "stylua.toml", ".stylua.toml" },
              { upward = true, path = ctx.dirname }
            )[1] ~= nil
          end,
        },
        ruff_format = {
          command = "uv",
          args = { "run", "ruff", "format", "--stdin-filename", "$FILENAME", "-" },
        },
      },
    })
  end,
}
