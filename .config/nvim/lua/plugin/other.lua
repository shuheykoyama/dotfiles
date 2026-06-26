---@type LazySpec

-- SvelteKit: +page/+layout の view(.svelte) <-> script(.ts/.js) <-> server(.server.*)。
-- script は glob で「存在するファイルだけ」を出す（target に `*` を含むと
-- showMissingFiles が無効化される other.nvim の仕様を利用）。
local sveltekit_target = {
  { target = "/%1/+%2.svelte", context = "view" },
  { target = "/%1/+%2\\(*.ts\\|*.js\\)", context = "script" },
}

return {
  "rgroli/other.nvim",
  cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
  commit = "1d48e090f6d1d53dda9fb5094af3f2006ebbb858",
  keys = {
    -- generic (ryoppippi 準拠)
    { "soo", "<cmd>Other<CR>", desc = "Other (alternate file)" },
    { "sov", "<cmd>OtherVSplit<CR>", desc = "Other (vsplit)" },
    { "sos", "<cmd>OtherSplit<CR>", desc = "Other (split)" },
    { "<leader><TAB>", "<cmd>Other<CR>", desc = "Other (alternate file)" },
    -- context 指定 (公式パターン)
    { "sow", "<cmd>Other view<CR>", desc = "Other: view" },
    { "soc", "<cmd>Other script<CR>", desc = "Other: script" },
    { "sot", "<cmd>Other test<CR>", desc = "Other: test" },
    { "soi", "<cmd>Other implementation<CR>", desc = "Other: implementation" },
    { "sob", "<cmd>Other benchmark<CR>", desc = "Other: benchmark" },
    { "soe", "<cmd>Other example<CR>", desc = "Other: example" },
  },
  opts = {
    mappings = {
      -- builtin（context は既に単語1つ: test / implementation）
      "react",
      "golang",

      -- python: builtin を単語1つ context に付け替え（パターン/ターゲットは builtin のまま）
      { pattern = "(.*)/(.*)%.py$", target = "**/test_%2.py", context = "test" },
      { pattern = "(.*)/test_(.*)%.py$", target = "**/%2.py", context = "implementation" },

      -- rust: builtin を単語1つ context に付け替え（src <-> tests / benches / examples の全スコープ保持）
      { pattern = "/src/(.*)/(.*)%.rs$", target = "/tests/%1/test_%2.rs", context = "test" },
      { pattern = "/tests/(.*)/test_(.*)%.rs$", target = "/src/%1/%2.rs", context = "implementation" },
      { pattern = "/src/(.*)%.rs$", target = "/tests/test_%1.rs", context = "test" },
      { pattern = "/tests/test_(.*)%.rs$", target = "/src/%1.rs", context = "implementation" },
      { pattern = "/src/(.*)/(.*)%.rs$", target = "/benches/%1/bench_%2.rs", context = "benchmark" },
      { pattern = "/benches/(.*)/bench_(.*)%.rs$", target = "/src/%1/%2.rs", context = "implementation" },
      { pattern = "/src/(.*)%.rs$", target = "/benches/bench_%1.rs", context = "benchmark" },
      { pattern = "/benches/bench_(.*)%.rs$", target = "/src/%1.rs", context = "implementation" },
      { pattern = "/src/(.*)/(.*)%.rs$", target = "/examples/%1/ex_%2.rs", context = "example" },
      { pattern = "/examples/(.*)/ex_(.*)%.rs$", target = "/src/%1/%2.rs", context = "implementation" },
      { pattern = "/src/(.*)%.rs$", target = "/examples/ex_%1.rs", context = "example" },
      { pattern = "/examples/ex_(.*)%.rs$", target = "/src/%1.rs", context = "implementation" },

      -- sveltekit（.server.* を先に判定、`[^.]*` で +page.ts が +page.server.ts を拾わないように）
      { pattern = "/(.*)/%+(.*)%.server%.ts$", target = sveltekit_target },
      { pattern = "/(.*)/%+(.*)%.server%.js$", target = sveltekit_target },
      { pattern = "/(.*)/%+([^.]*)%.ts$", target = sveltekit_target },
      { pattern = "/(.*)/%+([^.]*)%.js$", target = sveltekit_target },
      { pattern = "/(.*)/%+([^.]*)%.svelte$", target = sveltekit_target },
    },
  },
  config = function(_, opt)
    require("other-nvim").setup(opt)
  end,
}
