return {
  "wintermute-cell/gitignore.nvim",
  cmd = { "Gitignore" },
  -- Note: gitignore.nvim lists telescope.nvim as an optional dependency for
  -- multi-select. We use Snacks.picker instead and run in single-select mode;
  -- no plugin dependency needs to be declared.
}
