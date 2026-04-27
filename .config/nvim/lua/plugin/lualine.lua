return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "AndreM222/copilot-lualine",
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    -- Shared root marker set: referenced by both the root_dir component (lualine_c[1])
    -- and the pretty_path filename component below.
    local root_patterns = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" }

    -- LazyUtil.norm equivalent (lazy.core.util.norm). Unlike vim.fs.normalize, this does
    -- NOT resolve `..`/`.` or expand env vars — it only handles tilde, separator
    -- normalization, and trailing-slash trimming. For typical inputs (realpath outputs,
    -- expand("%:p"), client.root_dir, uri_to_fname) the two produce identical output;
    -- inlining this matches what LazyVim's pretty_path uses verbatim.
    local function norm(path)
      if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
          home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
      end
      path = path:gsub("\\", "/"):gsub("/+", "/")
      return path:sub(-1) == "/" and path:sub(1, -2) or path
    end

    -- Per-buffer root cache for pretty_path. Buffer-scoped events invalidate single
    -- entries; DirChanged is a cwd event with no buffer affinity, so we clear the
    -- entire cache because cwd-derived roots can become stale across all buffers.
    local root_cache = {}
    local root_aug = vim.api.nvim_create_augroup("lualine_pretty_path_root_cache", { clear = true })
    vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "BufEnter" }, {
      group = root_aug,
      callback = function(ev)
        root_cache[ev.buf] = nil
      end,
    })
    vim.api.nvim_create_autocmd("DirChanged", {
      group = root_aug,
      callback = function()
        root_cache = {}
      end,
    })

    return {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            function()
              local root = vim.fs.root(0, root_patterns)
              return vim.fs.basename(root or vim.uv.cwd() or "")
            end,
            padding = { left = 1, right = 1 },
          },
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            -- pretty_path: cwd-relative, smart segment truncation (first/…/last2),
            -- modified/readonly highlighted via vim hl groups (MatchParen / Bold).
            -- Equivalent to LazyVim.lualine.pretty_path() without the helper module.
            function(self)
              local path = vim.fn.expand("%:p")
              if path == "" then
                return ""
              end
              path = norm(path)

              -- realpath helper: LazyVim avoids fs_realpath on Windows. On non-Windows,
              -- a fs_realpath failure (new/unwritten files, missing workspace paths)
              -- returns nil — matching LazyVim's util/root.lua behavior verbatim.
              local function realpath(p)
                if not p or p == "" then
                  return nil
                end
                if vim.fn.has("win32") == 0 then
                  local r = vim.uv.fs_realpath(p)
                  if not r then
                    return nil
                  end
                  p = r
                end
                return norm(p)
              end

              local cwd = realpath(vim.uv.cwd()) or norm(vim.uv.cwd())

              local buf = vim.api.nvim_get_current_buf()
              local root = root_cache[buf]
              if not root then
                local bufpath = realpath(vim.api.nvim_buf_get_name(buf))

                -- LSP detector: collect workspace_folders + root_dir from clients
                -- (after filtering by vim.g.root_lsp_ignore), then keep only roots
                -- whose normalized path strictly contains bufpath.
                local lsp_roots = {}
                if bufpath then
                  local clients = vim.lsp.get_clients({ bufnr = buf })
                  clients = vim.tbl_filter(function(c)
                    return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, c.name)
                  end, clients)
                  for _, client in pairs(clients) do
                    for _, ws in pairs(client.config.workspace_folders or {}) do
                      lsp_roots[#lsp_roots + 1] = vim.uri_to_fname(ws.uri)
                    end
                    if client.root_dir then
                      lsp_roots[#lsp_roots + 1] = client.root_dir
                    end
                  end
                  -- Strict containment: bufpath == np OR bufpath starts with `np .. "/"`.
                  -- This is intentionally tighter than LazyVim's prefix-only match,
                  -- which would accept `/repo/app` as a parent of `/repo/application/...`.
                  -- Windows paths are case-insensitive; lowercase before comparing
                  -- (matches the lower-case logic used downstream for cwd/root matching).
                  local is_win = vim.uv.os_uname().sysname:find("Windows") ~= nil
                  lsp_roots = vim.tbl_filter(function(p)
                    local np = realpath(p)
                    if not np then
                      return false
                    end
                    local bp = bufpath
                    if is_win then
                      bp = bp:lower()
                      np = np:lower()
                    end
                    return bp == np or bp:sub(1, #np + 1) == np .. "/"
                  end, lsp_roots)
                end

                -- Apply realpath, dedupe, then sort by descending length so the most
                -- specific (deepest) root wins.
                local function dedupe_sort(paths)
                  local out = {}
                  for _, p in ipairs(paths) do
                    local pp = realpath(p)
                    if pp and not vim.tbl_contains(out, pp) then
                      out[#out + 1] = pp
                    end
                  end
                  table.sort(out, function(a, b)
                    return #a > #b
                  end)
                  return out
                end

                local roots = dedupe_sort(lsp_roots)
                if #roots == 0 then
                  -- Pattern fallback: shares root_patterns with the root_dir component above
                  local pat = vim.fs.root(buf, root_patterns)
                  if pat then
                    roots = dedupe_sort({ pat })
                  end
                end

                root = roots[1] or cwd
                root_cache[buf] = root
              end

              local norm_path, norm_cwd, norm_root = path, cwd, root
              if vim.uv.os_uname().sysname:find("Windows") then
                norm_path = norm_path:lower()
                norm_cwd = norm_cwd:lower()
                norm_root = norm_root:lower()
              end
              if norm_path:find(norm_cwd, 1, true) == 1 then
                path = path:sub(#cwd + 2)
              elseif norm_path:find(norm_root, 1, true) == 1 then
                path = path:sub(#root + 2)
              end

              local sep = package.config:sub(1, 1)
              local parts = vim.split(path, "[\\/]")
              local length = 3
              if #parts > length then
                parts = { parts[1], "…", unpack(parts, #parts - length + 2, #parts) }
              end

              -- Inline equivalent of LazyVim's M.format: cache a lualine hl group derived
              -- from a vim hl group (fg + bold/italic), apply it around `text`, then reset.
              self._pp_cache = self._pp_cache or {}
              local hl_utils = require("lualine.utils.utils")
              local function format(text, hl_group)
                text = text:gsub("%%", "%%%%")
                if not hl_group or hl_group == "" then
                  return text
                end
                local token = self._pp_cache[hl_group]
                if not token then
                  local gui = vim.tbl_filter(function(x)
                    return x
                  end, {
                    hl_utils.extract_highlight_colors(hl_group, "bold") and "bold",
                    hl_utils.extract_highlight_colors(hl_group, "italic") and "italic",
                  })
                  token = self:create_hl({
                    fg = hl_utils.extract_highlight_colors(hl_group, "fg"),
                    gui = #gui > 0 and table.concat(gui, ",") or nil,
                  }, "PP_" .. hl_group)
                  self._pp_cache[hl_group] = token
                end
                return self:format_hl(token) .. text .. self:get_default_hl()
              end

              parts[#parts] = format(parts[#parts], vim.bo.modified and "MatchParen" or "Bold")

              local dir = ""
              if #parts > 1 then
                local dir_raw = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
                dir = (dir_raw:gsub("%%", "%%%%"))
              end

              local readonly = ""
              if vim.bo.readonly then
                readonly = format(" 󰌾 ", "MatchParen")
              end

              return dir .. parts[#parts] .. readonly
            end,
          },
        },
        lualine_x = {
          Snacks.profiler.status(),
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Statement") }
            end,
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          { "copilot" },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "oil", "lazy", "mason", "quickfix" },
    }
  end,
}
