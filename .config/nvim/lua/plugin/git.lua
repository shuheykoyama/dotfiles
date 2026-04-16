return {
  "dinhhuy258/git.nvim",
  lazy = true,
  event = "BufReadPre",
  opts = {
    keymaps = {
      -- Open blame window
      blame = "<Leader>gb",
      -- Open file/folder in git repository
      browse = "<Leader>go",
    },
  },
}
