return {
  "nvim-mini/mini.icons",
  version = false,
  lazy = true,
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = function(_, opts)
    local MiniIcons = require("mini.icons")
    MiniIcons.setup(opts)
    MiniIcons.mock_nvim_web_devicons()
  end,
}
