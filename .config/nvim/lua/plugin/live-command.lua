return {
  "smjonas/live-command.nvim",
  cmd = { "Norm" },
  opts = {
    commands = {
      Norm = { cmd = "norm" },
    },
  },
  config = function(_, opt)
    require("live-command").setup(opt)
  end,
}
