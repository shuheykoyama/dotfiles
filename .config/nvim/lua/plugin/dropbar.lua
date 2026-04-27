return {
  "Bekaboo/dropbar.nvim",
  event = "BufReadPost",
  keys = {
    {
      "<leader>h",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Dropbar Pick",
    },
  },
  opts = function()
    local function close_menu()
      local menu = require("dropbar.api").get_current_dropbar_menu()
      if not menu then
        return
      end
      local parent_menu = menu.parent_menu
      if parent_menu then
        parent_menu:close()
      else
        menu:close()
      end
    end

    return {
      bar = {
        enable = function(buf, win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          local stat = bufname ~= "" and vim.uv.fs_stat(bufname) or nil
          return not vim.api.nvim_win_get_config(win).zindex
            and vim.bo[buf].buftype == ""
            and bufname ~= ""
            and not vim.wo[win].diff
            and (not stat or stat.size <= 1024 * 1024)
        end,
        pick = {
          pivots = "asdfghjklzxcvbnm,./qwertyuiop",
        },
      },
      sources = {
        path = {
          modified = function(sym)
            return sym:merge({
              name = sym.name,
              icon = " ",
              name_hl = "DiffAdded",
              icon_hl = "DiffAdded",
            })
          end,
        },
      },
      menu = {
        keymaps = {
          ["h"] = "<C-w>c",
          ["l"] = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if not menu then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then
              menu:click_on(component, nil, 1, "l")
            end
          end,
          ["<ESC>"] = close_menu,
          ["q"] = close_menu,
        },
      },
    }
  end,
}
