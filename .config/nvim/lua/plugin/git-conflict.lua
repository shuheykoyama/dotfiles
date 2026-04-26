return {
  "akinsho/git-conflict.nvim",
  lazy = true,
  init = function()
    -- Only load the plugin when a buffer actually contains conflict markers.
    -- Scans the first 500 lines for `<<<<<<<`; if found, force-loads the
    -- plugin (its own setup registers BufReadPost handlers to take over).
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("git_conflict_detect", { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
          return
        end
        local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 500, false)
        for _, line in ipairs(lines) do
          if vim.startswith(line, "<<<<<<<") then
            require("lazy").load({ plugins = { "git-conflict.nvim" } })
            vim.api.nvim_del_augroup_by_name("git_conflict_detect")
            return
          end
        end
      end,
    })
  end,
  config = true,
}
