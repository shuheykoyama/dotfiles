return {
  {
    "saghen/blink.cmp",
    lazy = true,
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    -- NOTE: completion-source plugins are intentionally NOT listed here.
    -- Listing them as dependencies makes lazy.nvim load them when blink loads,
    -- and blink is force-loaded at BufReadPre (nvim-lspconfig declares it as a
    -- dependency for get_lsp_capabilities()). To keep the source-loading cost
    -- off the BufReadPre wave, the heavy sources are split into standalone specs
    -- below, deferred to InsertEnter/CmdlineEnter or first-completion require.
    -- Only friendly-snippets (snippet DATA, no lua module to lazy-require) stays
    -- as a dependency. Every source PLUGIN is split into a standalone spec below.
    dependencies = {
      "rafamadriz/friendly-snippets",
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
      snippets = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        -- kind icons mirror ryoppippi lspkind symbol_map (codicons preset + overrides)
        kind_icons = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "",
          Value = "󰎠",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
          Copilot = "",
        },
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
          -- blink's default 500ms debounce: avoids firing a docs resolve+render
          -- on every transient selection. ryoppippi/nvim-cmp is eager (0); we
          -- adopt blink's debounce as the blink-appropriate choice.
          auto_show_delay_ms = 500,
          window = { winblend = 30 },
        },
      },
      signature = {
        enabled = false, -- ryoppippi: cmp-nvim-lsp-signature-help enabled=false
      },
      fuzzy = {
        -- ryoppippi comparator chain: offset, exact, score, under, kind,
        -- recently_used, locality, sort_text, length, order. Mapped to blink's
        -- string-only sorts so sorting stays in Rust (a custom Lua sort func
        -- disables the Rust sort path — fuzzy/init.lua:115 — and blink's docs
        -- advise against it). frecency(=recently_used) and proximity(=locality)
        -- fold into `score`; `offset` has no blink equivalent (handled
        -- internally); under + length are both covered by the built-in `label`
        -- sort. Only the exact comparator *position* of under/length differs
        -- (bundled in `label`), which is imperceptible in practice.
        frecency = { enabled = true },  -- recently_used
        use_proximity = true,           -- locality
        sorts = {
          "exact",
          "score", -- frecency(recently_used) + proximity(locality) folded in
          "kind",
          "sort_text",
          "label", -- under (leading "_" deprioritized) + length + case-aware alpha, all in Rust
        },
      },
      sources = {
        -- ryoppippi nvim-cmp parity: 2 groups via cmp.config.sources(g1, g2).
        -- g2 (fallback) shows only when the GATING g1 sources return nothing.
        -- Only context-shaped sources gate g2: lsp, path, lazydev. snippets and
        -- emoji stay top-level/non-gating — blink falls back on raw, pre-filter
        -- item counts and they return full lists, so gating on them would
        -- over-suppress g2.
        default = {
          "lsp",       -- ryoppippi: priority=100
          "path",      -- ryoppippi: priority=100
          "snippets",  -- friendly-snippets (ryoppippi uses denippet/Deno; excluded by policy)
          "emoji",     -- ryoppippi: priority=50
          -- g2 (ryoppippi group_index=2): shown only when lsp/path/lazydev empty
          "buffer",
          "omni",
          "calc",
          "spell",
          "treesitter",
          "dictionary", -- ryoppippi の look 相当 (/usr/share/dict/words 英単語補完)
        },
        per_filetype = {
          -- lua: inherit the default sources and add lazydev (lua-only source).
          -- inherit_defaults merges with `default` instead of replacing it, so
          -- lazydev is requested only for lua buffers (never loaded on non-lua).
          lua = { inherit_defaults = true, "lazydev" },
          -- ryoppippi {gitcommit, octo, markdown}: g1 git, ghq, nvim_lsp,
          -- async_path, emoji → g2 buffer, omni, spell, calc, treesitter, look.
          -- Here git/ghq are top-level/non-gating (see providers); the gating g1
          -- is lsp/path; g2 = buffer/omni/spell/calc/treesitter/dictionary.
          gitcommit = {
            "git", "ghq", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
          octo = {
            "git", "ghq", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
          markdown = {
            "git", "ghq", "lsp", "path", "snippets", "emoji",
            "buffer", "omni", "spell", "calc", "treesitter", "dictionary",
          },
        },
        providers = {
          -- g1 gater (ryoppippi priority=100). Its `fallbacks` ARE the g2 group:
          -- g2 runs only when this (and the other gaters) return no raw items.
          lsp = {
            name = "LSP",
            score_offset = 5, -- ryoppippi: priority=100, equal to path
            fallbacks = { "buffer", "omni", "calc", "spell", "treesitter", "dictionary" },
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
            fallbacks = { "buffer", "omni", "calc", "spell", "treesitter", "dictionary" },
          },
          -- g1 gater (ryoppippi nvim_lua, priority=50) → lazydev (lua-only).
          lazydev = {
            name = "Lua", -- ryoppippi nvim_lua label [Lua]
            module = "lazydev.integrations.blink",
            score_offset = 3, -- ryoppippi: priority=50, same as emoji/nvim_lua
            fallbacks = { "buffer", "omni", "calc", "spell", "treesitter", "dictionary" },
          },
          -- non-gating top-level: emoji returns the full table once ":" triggers
          -- (pre-filter), so gating g2 on it would over-suppress. (ryoppippi g1.)
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 3, -- ryoppippi: priority=50
            opts = { insert = true },
          },
          -- non-gating top-level: blink's snippets source returns all filetype
          -- snippets (pre-filter), so gating g2 on it would over-suppress.
          -- friendly-snippets (ryoppippi has no snippet source — denippet excluded).
          snippets = {
            name = "Snippets",
            score_offset = 0,
          },
          -- g2 (ryoppippi group_index=2): gated via the gaters' `fallbacks`
          -- above; g2 providers carry no `fallbacks` themselves.
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
            -- blink.compat looks the nvim-cmp source up by cmp_name (falls back
            -- to `name`); cmp-calc registers as lowercase "calc", so set it
            -- explicitly — otherwise the "Calc" name never matches the registry.
            opts = { cmp_name = "calc" },
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -5,
          },
          treesitter = {
            name = "TS", -- ryoppippi label [TS]
            module = "blink.compat.source",
            score_offset = -5,
            opts = { cmp_name = "treesitter" }, -- match cmp-treesitter's lowercase registry name
          },
          -- ryoppippi の look 相当 (/usr/share/dict/words 英単語補完)。
          -- capitalize_first(=convert_case) と capitalize_whole_word(=loud) は
          -- blink-cmp-dictionary の既定 ON なので追加設定不要。
          dictionary = {
            name = "Look", -- ryoppippi label [Look]
            module = "blink-cmp-dictionary",
            score_offset = -5,
            min_keyword_length = 2, -- ryoppippi: keyword_length=2
            -- blink-cmp-dictionary perf tip: cap items (blink re-fuzzies
            -- downstream), keeps the per-query fzf/word work cheap.
            max_items = 8,
            opts = { dictionary_files = { "/usr/share/dict/words" } },
          },
          -- non-gating top-level: ghq returns a broad repo list regardless of
          -- context (pre-filter), so it must not gate g2.
          ghq = {
            name = "GHQ", -- ryoppippi label [GHQ]
            module = "blink-cmp-ghq", -- native blink source (not via blink.compat)
            async = true,             -- shells out to `ghq list -p`; don't block blink
            score_offset = 50,        -- ryoppippi: filetype group1 (high priority)
          },
          -- non-gating top-level: cmp-git may not call back when no trigger
          -- matches, which would delay g2; keep it from gating.
          git = {
            name = "Git",
            module = "cmp_git.blink", -- native blink source (not via blink.compat)
            opts = { filetypes = { "gitcommit", "octo" } }, -- ryoppippi: not markdown
            score_offset = 50,
          },
          -- Cmdline-only providers
          cmdline_history = {
            name = "History", -- ryoppippi label [History]
            module = "blink.compat.source",
            score_offset = -5,
            -- compat lookup key = opts.cmp_name or name; keep it matching the
            -- registered "cmdline_history" despite the display rename.
            opts = { cmp_name = "cmdline_history" },
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
        completion = {
          -- Auto-show the popup menu while typing in ":" / "/" / "?". blink's
          -- default only auto-shows in the cmdwin (q:); the normal cmdline needs
          -- <Tab> otherwise. true matches nvim-cmp/ryoppippi behaviour.
          menu = { auto_show = true },
          -- ryoppippi cmdline completeopt "menu,menuone,noselect": no preselect,
          -- insert allowed (blink default is preselect=true).
          list = { selection = { preselect = false, auto_insert = true } },
          -- ryoppippi disables ghost_text globally (experimental.ghost_text=false);
          -- also avoids copilot conflict. blink enables it for cmdline by default.
          ghost_text = { enabled = false },
        },
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

  -- Completion-source plugins, split out of blink's `dependencies` so they do
  -- NOT load on the BufReadPre wave (blink itself stays at BufReadPre for
  -- get_lsp_capabilities()). Deliberate exception to the one-file-per-plugin
  -- rule: these are all blink.cmp sources whose provider wiring lives above.
  --
  -- Native blink sources: blink `require(module)`s these lazily at first
  -- completion in their context, so no event trigger is needed.
  { "delphinus/cmp-ghq", lazy = true },
  {
    "petertriho/cmp-git",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- blink.compat sources: blink.compat only finds them once their own
  -- after/plugin has registered them, so each needs a load trigger before its
  -- first query. Buffer sources → InsertEnter; cmdline sources → CmdlineEnter.
  { "hrsh7th/cmp-calc", event = "InsertEnter" },
  { "ray-x/cmp-treesitter", event = "InsertEnter" },
  { "dmitmel/cmp-cmdline-history", event = "CmdlineEnter" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "CmdlineEnter" },

  -- Native sources from sources.default, split out so they don't load on the
  -- BufReadPre wave; blink requires their module at provider instantiation.
  { "Kaiser-Yang/blink-cmp-dictionary", lazy = true }, -- v3.0: zero-dependency
  { "moyiz/blink-emoji.nvim", lazy = true },
  { "ribru17/blink-cmp-spell", lazy = true },
  -- blink.compat: loads on demand when a compat source require("cmp")s it, or
  -- when blink instantiates a compat provider (require("blink.compat.source")).
  -- Track main, not the latest tag: v2.5.0 calls a cmp source's
  -- get_keyword_pattern() with NO args, which crashes sources that read
  -- `params.option` (e.g. cmp-treesitter). The fix (732bfbb, "pass option to
  -- get_keyword_pattern") is on main but unreleased — v2.5.0 predates it. main
  -- is dormant (4 commits ahead, last 2025-05) so the risk is minimal.
  { "saghen/blink.compat", branch = "main", lazy = true, opts = {} },
  -- lazydev: lua-only (configures lua_ls library). ft=lua loads it for lua
  -- buffers; its blink source is requested only via per_filetype.lua above.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
