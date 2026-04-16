return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  ft = "rust",
  ---@type rustaceanvim.Opts
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = opts
  end,
}
