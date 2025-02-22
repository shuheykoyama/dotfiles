return {
  {
    "giuxtaposition/blink-cmp-copilot",
  },
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
      "L3MON4D3/LuaSnip",
    },
    opts_extend = {
      "sources.default",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = {
            columns = {
              { "label", "kind_icon", gap = 1 },
              { "kind" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
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
                  if kind_str == "Copilot" then
                    return ""
                  else
                    local icon, _, _ = require("mini.icons").get("lsp", kind_str)
                    return icon or ""
                  end
                end,
                highlight = function(ctx)
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
                  if kind_str == "Copilot" then
                    return "CmpItemKindCopilot"
                  else
                    local _, hl, _ = require("mini.icons").get("lsp", kind_str)
                    return hl or "CmpItemKind"
                  end
                end,
              },
              label = {
                text = function(item)
                  return item.label
                end,
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end

                  -- characters matched on the label by the fuzzy matcher
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return highlights
                end,
              },
              kind = {
                text = function(item)
                  return item.kind
                end,
                highlight = "CmpItemKind",
              },
            },
          },
          border = "none",
          winblend = 10,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
            winblend = 10,
          },
        },
        -- ghost_text = {
        --   enabled = true,
        -- },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winblend = 10,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          -- lsp = {
          --   name = "lsp",
          --   enabled = true,
          --   module = "blink.cmp.sources.lsp",
          --   kind = "LSP",
          --   score_offset = 1000, -- the higher the number, the higher the priority
          -- },
          -- luasnip = {
          --   name = "luasnip",
          --   enabled = true,
          --   module = "blink.cmp.sources.luasnip",
          --   score_offset = 950, -- the higher the number, the higher the priority
          -- },
          -- snippets = {
          --   name = "snippets",
          --   enabled = true,
          --   module = "blink.cmp.sources.snippets",
          --   score_offset = 900, -- the higher the number, the higher the priority
          -- },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100, -- the higher the number, the higher the priority
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-s>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
    },
  },
}
