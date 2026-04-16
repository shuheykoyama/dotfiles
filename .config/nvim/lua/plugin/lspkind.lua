return {
  "onsails/lspkind.nvim",
  config = function(_, opts)
    require("lspkind").init(opts)
  end,
  opts = {
    preset = "codicons",
    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "󰉿 ",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = " ",
      Field = "󰜢",
      Variable = " ",
      Class = "󰠱",
      Interface = " ",
      Module = " ",
      Property = "󰜢",
      Unit = " ",
      Value = "󰎠 ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = "󰏘",
      File = "󰈙 ",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = " ",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = " ",
      Copilot = " ",
    },
  },
}
