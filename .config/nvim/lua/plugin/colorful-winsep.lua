return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
  opts = {
    -- Replace upstream defaults that don't match this config
    -- (packer → lazy, TelescopePrompt → Snacks.picker) with the
    -- special-buffer filetypes ordinary windows actually open here.
    excluded_ft = { "snacks_dashboard", "lazy", "oil", "mason", "help" },
    -- The shift animation on every split/close is visual noise without
    -- adding information; keep the colored separators (and the
    -- 2-window directional indicator) but skip the animated transition.
    animate = { enabled = false },
  },
}
