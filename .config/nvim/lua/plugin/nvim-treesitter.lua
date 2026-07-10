---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- The main branch does not support lazy-loading (upstream README). This is an
  -- intentional exception to the repo's avoid-lazy=false policy, required for
  -- correctness; parser compilation happens out-of-band via :TSInstall/:TSUpdate.
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "David-Kunz/treesitter-unit" },
  },
  config = function()
    -- setup() is optional on main; auto_install/ensure_installed no longer exist.
    -- Parsers are installed explicitly with :TSInstall / :TSUpdate.
    require("nvim-treesitter").setup()

    -- Highlighting does not auto-start on main: start it per file buffer.
    -- Named augroup + clear avoids duplicate handlers on reload; skip non-file
    -- buffers and very large files.
    local group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true })
    local function ts_start(buf)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if vim.bo[buf].buftype ~= "" then
        return
      end
      if vim.api.nvim_buf_line_count(buf) > 50000 then
        return
      end
      pcall(vim.treesitter.start, buf)
    end
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        ts_start(args.buf)
      end,
    })
    -- Cover buffers already loaded when this config runs (their FileType may
    -- have fired before the plugin loaded).
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        ts_start(buf)
      end
    end
  end,
}
