return {
  {
    "saghen/blink.cmp",
    lazy = true,
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "Kaiser-Yang/blink-cmp-avante",
      -- icon & color
      "brenoprata10/nvim-highlight-colors",
      -- sources
      "ribru17/blink-cmp-spell",
      "moyiz/blink-emoji.nvim",
      {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
      },
      "hrsh7th/cmp-calc",
      "ray-x/cmp-treesitter",
      -- lazydev.nvim: Neovim Lua API 補完 (cmp-nvim-lua の代替、lsp ソース経由で動作)
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "Kaiser-Yang/blink-cmp-dictionary", dependencies = { "nvim-lua/plenary.nvim" } },
      "delphinus/cmp-ghq",    -- ghq source (requires ghq installed)
      {
        "petertriho/cmp-git",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { filetypes = { "gitcommit", "octo", "markdown" } },
        config = true,
      },
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      { "kristijanhusak/vim-dadbod-completion", optional = true },
    },
    opts_extend = {
      "sources.default",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- snacks.picker の入力欄で blink.cmp が発火しないよう除外
      enabled = function()
        return not vim.tbl_contains({ "snacks_picker_input", "snacks_input" }, vim.bo[0].filetype)
      end,
      snippets = { preset = "luasnip" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = { enabled = false }, -- ryoppippi: no auto_brackets
        },
        ghost_text = {
          enabled = false, -- avoid conflict with copilot inline suggestion
        },
        list = {
          selection = {
            preselect = false,   -- ryoppippi: select=false (明示選択のみ確定)
            auto_insert = false, -- 自動挿入しない
          },
        },
        menu = {
          winblend = 30,
          draw = {
            columns = {
              { "kind_icon", "kind", gap = 1 }, -- lspkind mode="symbol_text" 相当
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  -- Step 1: nvim-highlight-colors for color swatches
                  local ok_nhc, nhc = pcall(require, "nvim-highlight-colors")
                  if ok_nhc then
                    local color_item = nhc.format(ctx.item, { kind = ctx.kind })
                    if color_item and color_item.abbr and color_item.abbr ~= "" then
                      return color_item.abbr
                    end
                  end

                  -- Resolve kind string
                  local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                  local kind_str
                  if type(ctx.kind) == "number" then
                    kind_str = CompletionItemKind[ctx.kind]
                  elseif type(ctx.kind) == "string" then
                    kind_str = ctx.kind
                  end
                  if type(kind_str) ~= "string" then
                    kind_str = "Text"
                  end

                  -- Step 2: Path source → mini.icons for file-type icons
                  if ctx.source_name == "Path" then
                    local ok_mi, mi = pcall(require, "mini.icons")
                    if ok_mi then
                      local icon = mi.get("file", ctx.label)
                      if icon then
                        return icon .. " "
                      end
                    end
                  end


                  return ctx.kind_icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  -- Step 1: nvim-highlight-colors highlight
                  local ok_nhc, nhc = pcall(require, "nvim-highlight-colors")
                  if ok_nhc then
                    local color_item = nhc.format(ctx.item, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      return color_item.abbr_hl_group
                    end
                  end

                  -- Resolve kind string
                  local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                  local kind_str
                  if type(ctx.kind) == "number" then
                    kind_str = CompletionItemKind[ctx.kind]
                  elseif type(ctx.kind) == "string" then
                    kind_str = ctx.kind
                  end
                  if type(kind_str) ~= "string" then
                    kind_str = "Text"
                  end

                  -- Copilot custom highlight
                  if kind_str == "Copilot" then
                    return "CmpItemKindCopilot"
                  end

                  -- Path source → mini.icons highlight
                  if ctx.source_name == "Path" then
                    local ok_mi, mi = pcall(require, "mini.icons")
                    if ok_mi then
                      local _, hl = mi.get("file", ctx.label)
                      if hl then
                        return hl
                      end
                    end
                  end

                  return "BlinkCmpKind" .. kind_str
                end,
              },
              label = {
                width = { fill = true, max = 50 }, -- ryoppippi: maxwidth=50
                text = function(ctx)
                  return ctx.label .. (ctx.label_detail or "")
                end,
                highlight = function(ctx)
                  local highlights = {
                    {
                      0,
                      #ctx.label,
                      group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                    },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
                end,
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  if ctx.source_name == "LSP" and ctx.item and ctx.item.client_id then
                    local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                    if client then
                      return "{" .. client.name .. "}"
                    end
                  end
                  return "[" .. ctx.source_name .. "]"
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { winblend = 30 },
        },
      },
      signature = {
        enabled = false, -- ryoppippi: cmp-nvim-lsp-signature-help enabled=false
      },
      fuzzy = {
        -- ryoppippi: offset, exact, score, cmp-under-comparator, kind, recently_used,
        --            locality, sort_text, length, order
        frecency = { enabled = true },  -- recently_used 相当
        use_proximity = true,           -- locality 相当
        sorts = {
          "exact",
          "score",
          "kind",
          "sort_text",
          "label", -- underscore 下位 + アルファベット順 + 短い候補優先 (cmp-under-comparator + length 相当)
        },
      },
      sources = {
        default = {
          "avante",    -- user addition (≈ ryoppippi's AI tool)
          "lsp",       -- ryoppippi: priority=100
          "path",      -- ryoppippi: priority=100
          "snippets",  -- ryoppippi: luasnip priority=20
          "emoji",     -- ryoppippi: priority=50
          "lazydev",   -- Neovim Lua API 補完 (cmp-nvim-lua 代替)
          -- fallback group (ryoppippi: group_index=2)
          "buffer",
          "omni",
          "calc",
          "spell",
          "treesitter",
          "dictionary", -- ryoppippi の look ソース代替 (cmp-look は nvim-cmp 依存のため)
        },
        per_filetype = {
          sql   = { "dadbod", "lsp", "path", "snippets", "buffer" },
          mysql = { "dadbod", "lsp", "path", "snippets", "buffer" },
          plsql = { "dadbod", "lsp", "path", "snippets", "buffer" },
          -- ryoppippi: git, ghq, luasnip, nvim_lsp, async_path, emoji, codecompanion
          --          → buffer, omni, spell, calc, treesitter, look
          gitcommit = {
            "git", "ghq", "avante", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
          octo = {
            "git", "ghq", "avante", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
          markdown = {
            "git", "ghq", "avante", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
        },
        providers = {
          -- User additions (AI sources)
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            score_offset = 90,
            fallbacks = { "buffer" },
          },
          -- ryoppippi group1 (priority=100, highest among non-AI)
          lsp = {
            name = "LSP",
            score_offset = 5, -- ryoppippi: priority=100, equal to path
            fallbacks = { "buffer", "omni", "treesitter" },
            -- ryoppippi: trigger_characters = { "-", ".", "/", ":" }
            override = {
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                vim.list_extend(trigger_characters, { "-", ".", "/", ":" })
                return trigger_characters
              end,
            },
          },
          path = {
            name = "Path",
            score_offset = 5, -- ryoppippi: priority=100, equal to lsp
            fallbacks = { "buffer" },
          },
          -- ryoppippi group1 (priority=50): nvim_lua → lazydev (blink-cmp native integration)
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 3, -- ryoppippi: priority=50, same as emoji/nvim_lua
          },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 3, -- ryoppippi: priority=50
            fallbacks = { "buffer" },
            opts = { insert = true },
          },
          -- ryoppippi group1 (priority=20, lowest in primary)
          snippets = {
            name = "Snippets",
            score_offset = 0, -- ryoppippi: luasnip priority=20
            fallbacks = { "buffer" },
          },
          -- ryoppippi group2 (fallback sources)
          buffer = {
            name = "Buffer",
            score_offset = -5,
          },
          omni = {
            name = "Omni",
            score_offset = -5,
          },
          calc = {
            name = "Calc",
            module = "blink.compat.source",
            score_offset = -5,
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -5,
          },
          treesitter = {
            name = "Treesitter",
            module = "blink.compat.source",
            score_offset = -5,
          },
          dictionary = {
            name = "Dictionary",
            module = "blink-cmp-dictionary",
            score_offset = -5,
            min_keyword_length = 2, -- ryoppippi: keyword_length=2
          },
          ghq = {
            name = "ghq",
            module = "blink.compat.source",
            score_offset = 50, -- ryoppippi: filetype group1 (high priority)
          },
          git = {
            name = "Git",
            module = "blink.compat.source",
            score_offset = 50,
          },
          -- Cmdline-only providers
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
            score_offset = 10,
          },
          cmdline_history = {
            name = "cmdline_history",
            module = "blink.compat.source",
            score_offset = -5,
          },
          lsp_document_symbol = {
            name = "nvim_lsp_document_symbol",
            module = "blink.compat.source",
            score_offset = 0,
          },
        },
      },
      cmdline = {
        enabled = true,
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            -- ryoppippi: group1=lsp_document_symbol, cmdline, ghq / group2=buffer
            return { "lsp_document_symbol", "cmdline", "ghq", "buffer" }
          end
          if type == ":" then
            -- ryoppippi: group1=path / group2=cmdline, cmdline_history
            return { "path", "cmdline", "cmdline_history" }
          end
          return {}
        end,
      },
      keymap = {
        preset = "enter",
        ["<C-l>"] = { "hide" },
        ["<C-y>"] = {},              -- ryoppippi: cmp.config.disable (明示的に無効化)
        ["<C-n>"] = { "fallback" },  -- ryoppippi: always fallback (補完選択に使わない)
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<A-j>"] = { "scroll_documentation_down", "fallback" },
        ["<A-k>"] = { "scroll_documentation_up", "fallback" },
        -- ryoppippi: has_words_before() チェーン
        -- 1. メニュー表示中 → 次候補選択
        -- 2. スニペットjump可能 → jump
        -- 3. カーソル前に文字あり → 補完メニューを開く
        -- 4. それ以外 → 通常のTab (インデント)
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then return cmp.select_next() end
          end,
          "snippet_forward",
          function(cmp)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            if col == 0 then return end
            local line = vim.api.nvim_get_current_line()
            if line:sub(col, col):match("%S") then
              cmp.show()
              return true
            end
          end,
          "fallback",
        },
        -- ryoppippi: visible() AND has_words_before() の両方を満たす場合のみ prev 選択
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local line = vim.api.nvim_get_current_line()
              if col ~= 0 and line:sub(col, col):match("%S") then
                return cmp.select_prev()
              end
            end
          end,
          "snippet_backward",
          "fallback",
        },
      },
    },
  },
}
