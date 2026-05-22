---@type LazySpec
return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  init = function()
    require("core.plugin").on_attach(function(client, bufnr)
      if client.name ~= "crates.nvim" then
        return
      end
      local crates = require("crates")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
      end

      -- toggle / reload
      map("n", "<leader>ct", crates.toggle, "Toggle crates.nvim")
      map("n", "<leader>cr", crates.reload, "Reload crates info")

      -- popups
      map("n", "<leader>cv", crates.show_versions_popup, "Show versions popup")
      map("n", "<leader>cf", crates.show_features_popup, "Show features popup")
      map("n", "<leader>cd", crates.show_dependencies_popup, "Show dependencies popup")

      -- update / upgrade
      map("n", "<leader>cu", crates.update_crate, "Update crate")
      map("v", "<leader>cu", crates.update_crates, "Update crates (selection)")
      map("n", "<leader>ca", crates.update_all_crates, "Update all crates")
      map("n", "<leader>cU", crates.upgrade_crate, "Upgrade crate")
      map("v", "<leader>cU", crates.upgrade_crates, "Upgrade crates (selection)")
      map("n", "<leader>cA", crates.upgrade_all_crates, "Upgrade all crates")

      -- expand / extract
      map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, "Expand plain crate to inline table")
      map("n", "<leader>cX", crates.extract_crate_into_table, "Extract crate into table")

      -- open links
      map("n", "<leader>cH", crates.open_homepage, "Open crate homepage")
      map("n", "<leader>cR", crates.open_repository, "Open crate repository")
      map("n", "<leader>cD", crates.open_documentation, "Open crate documentation (docs.rs)")
      map("n", "<leader>cC", crates.open_crates_io, "Open crate on crates.io")
      map("n", "<leader>cL", crates.open_lib_rs, "Open crate on lib.rs")
    end)
  end,
  opts = {
    completion = {
      crates = {
        enabled = true,
      },
    },
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
  },
}
