---@type LazySpec
return {
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
    },
    init = function()
      -- Disable built-in SQL omni completion (conflicts with vim-dadbod-completion)
      vim.g.loaded_sql_completion = 1
      vim.g.omni_sql_default_compl_type = "syntax"
      -- UI settings
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_execute_on_save = 0  -- manual execution (`:w` does not trigger query)
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.db_ui_tmp_query_location = vim.fn.stdpath("data") .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nvim_notify = 0
    end,
  },
}
