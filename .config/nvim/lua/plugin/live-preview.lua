---@type LazySpec
return {
  "brianhuster/live-preview.nvim",
  cmd = { "LivePreview" },
  keys = {
    {
      "<leader>mp",
      ft = "markdown",
      "<cmd>LivePreview start<cr>",
      desc = "Live Preview",
    },
  },
  opts = {
    -- Serve from the current file's parent directory so relative asset paths
    -- (./img.png, ../assets/) resolve correctly — matches how markdown files
    -- (incl. Obsidian notes) reference images.
    dynamic_root = true,
    -- Reuse the existing snacks picker for `:LivePreview pick` instead of
    -- letting it auto-detect telescope/fzf-lua/mini.pick (none installed here).
    picker = "snacks.picker",
  },
  config = function(_, opts)
    require("livepreview.config").set(opts)
  end,
}
