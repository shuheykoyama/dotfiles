return {
  "rcarriga/nvim-notify",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    render = "wrapped-compact",
    stages = "slide",
    timeout = 5000,
  },
}
