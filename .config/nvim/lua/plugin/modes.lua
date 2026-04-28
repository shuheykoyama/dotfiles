return {
  "mvllow/modes.nvim",
  event = "VeryLazy",
  opts = {
    -- Replace upstream defaults that don't match this config (NvimTree → oil,
    -- packer → lazy, Telescope → Snacks.picker, !minifiles → unused) with
    -- the special-buffer filetypes that ordinary windows actually open here.
    ignore = {
      "snacks_dashboard",
      "lazy",
      "oil",
      "mason",
      "help",
      "man",
      "checkhealth",
      "lspinfo",
    },
  },
}
