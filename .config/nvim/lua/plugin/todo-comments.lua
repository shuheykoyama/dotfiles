return {
  "folke/todo-comments.nvim",
  -- :TodoTrouble / :TodoTelescope commands aren't usable here (trouble.nvim removed,
  -- telescope not installed). Use Snacks.picker.todo_comments() instead (bound to `,t`).
  event = "BufReadPost",
  opts = {},
}
