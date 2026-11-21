if vim.loader then
  vim.loader.enable()
end

-- _G.dd = function(...)
--     require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

_G.Shuhey = require("shuhey.utils")
require("shuhey.config.options")
require("shuhey.config.keymaps")
require("shuhey.config.autocmds")
require("shuhey.config.commands")
require("shuhey.config.workarounds")
require("shuhey.plugins")
