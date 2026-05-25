---@type LazySpec
return {
  "vuki656/package-info.nvim",
  -- Lazy-load only when a buffer named `package.json` is opened. ft = "json"
  -- would also fire for tsconfig.json / deno.json etc. that package-info
  -- ignores internally (core.__is_valid_package_json matches `package.json$`).
  event = { "BufRead package.json", "BufNewFile package.json" },
  -- Direct invocation of any PackageInfo* user command also triggers load.
  -- The plugin exposes a Lua `toggle()` API but registers no
  -- `:PackageInfoToggle` ex command (see utils/constants.lua M.COMMANDS),
  -- so keymaps for toggle must call the Lua function directly.
  cmd = {
    "PackageInfoShow",
    "PackageInfoShowForce",
    "PackageInfoHide",
    "PackageInfoUpdate",
    "PackageInfoDelete",
    "PackageInfoInstall",
    "PackageInfoChangeVersion",
  },
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    autostart = false,
    notifications = false,
    hide_up_to_date = true,
    hide_unstable_versions = true,
  },
  config = function(_, opts)
    require("package-info").setup(opts)

    local function map_toggle(buf)
      vim.keymap.set("n", "<leader>cp", function()
        require("package-info").toggle()
      end, { buffer = buf, desc = "Package Info Toggle" })
    end

    -- Buffer-local keymap, only registered for `package.json` buffers so it
    -- never collides with global mappings (snacks <leader>n / shuhey paste).
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("package_info_keymap", { clear = true }),
      pattern = "package.json",
      callback = function(args)
        map_toggle(args.buf)
      end,
    })

    -- setup() registers a BufEnter autocmd that calls load_plugin() to flip
    -- state.is_loaded = true. When the plugin is lazy-loaded by an event/cmd
    -- trigger, BufEnter has already fired for the current buffer, so replay
    -- load_plugin + the keymap once here for the buffer that triggered load.
    if vim.fn.expand("%:t") == "package.json" then
      require("package-info.core").load_plugin()
      map_toggle(0)
    end
  end,
}
