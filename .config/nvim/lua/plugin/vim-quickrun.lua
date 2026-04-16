local function executable(cmd)
  return tb(vim.fn.executable(cmd))
end

---@type LazySpec
return {
  "thinca/vim-quickrun",
  cmd = "QuickRun",
  keys = {
    { "qr", "QuickRun", mode = "ca" },
  },
  dependencies = {
    { "tani/vim-artemis" },
    { "lambdalisue/vim-quickrun-neovim-job" },
  },
  config = function()
    vimx.g.quickrun_config = {
      -- Python: uv 優先、なければ python3
      python = executable("uv") and {
        command = "uv",
        exec = "%c run python %o %s",
      } or {
        command = "python3",
      },

      -- TypeScript: bun → tsx → ts-node → tsc+node → node --experimental-strip-types
      typescript = {
        type = executable("bun") and "typescript/bun" or executable("tsx") and "typescript/tsx" or executable(
          "ts-node"
        ) and "typescript/ts-node" or executable("tsc") and "typescript/tsc" or "typescript/node",
      },
      ["typescript/bun"] = {
        command = "bun",
        exec = "%c run %o %s",
        tempfile = "%{tempname()}.ts",
      },
      ["typescript/tsx"] = {
        command = "tsx",
        exec = "%c %o %s",
        tempfile = "%{tempname()}.ts",
      },
      -- typescript/ts-node, typescript/tsc は vim-quickrun 組み込み
      ["typescript/node"] = {
        command = "node",
        exec = "%c --experimental-strip-types %o %s",
        tempfile = "%{tempname()}.ts",
      },
    }
  end,
}
