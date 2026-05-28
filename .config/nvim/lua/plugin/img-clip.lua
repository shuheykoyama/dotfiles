---@type LazySpec
return {
  -- support for image pasting
  "HakonHarnes/img-clip.nvim",
  -- VeryLazy (not cmd/keys) because drag & drop overrides vim.paste() and must
  -- be active without an explicit trigger. <leader>p is taken by paste, so the
  -- clipboard command is bound to <leader>ip (image paste).
  event = "VeryLazy",
  keys = {
    { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image" },
  },
  opts = {
    default = {
      embed_image_as_base64 = false,
      -- Dragged local files keep their original path (no copy into assets/).
      copy_images = false,
      -- Relative paths so links stay portable across machines / git moves.
      use_absolute_path = false,
      -- Clipboard pastes (screenshots) have no source file, so confirm the
      -- name and directory before saving instead of writing silently.
      prompt_for_file_name = true,
      show_dir_path_in_prompt = true,
      drag_and_drop = {
        insert_mode = true,
      },
    },
    filetypes = {
      markdown = {
        -- Wrap the path in angle brackets (GFM) so filenames with spaces
        -- (e.g. macOS screenshots `Screenshot 2026-04-14 at 0.14.26.png`) work
        -- without URL-encoding.
        url_encode_path = false,
        template = "![$CURSOR](<$FILE_PATH>)",
      },
    },
  },
  config = function(_, opts)
    require("img-clip").setup(opts)

    -- Workaround for img-clip + ghostty/iTerm/Terminal/Wezterm D&D + spaces.
    -- These terminals shell-escape paths on drop (e.g. "Screenshot\ 2026.png"),
    -- but img-clip's fs.split_path uses the pattern "[^/\\]+" so it treats "\"
    -- as a path separator (for Windows support), which mangles spaced
    -- filenames into bogus multi-directory paths like "Screenshot/ 2026.png".
    -- See img-clip issue #129 (open since 2025-06). Until upstream fixes this,
    -- intercept vim.paste *before* img-clip and undo the `\<whitespace>`
    -- escape, but only on a single-line paste that looks like an image path
    -- so unrelated text pastes are untouched.
    local img_clip_paste = vim.paste
    -- Lua patterns have no `|` alternation, so check each extension separately.
    local function looks_like_image(s)
      s = s:lower()
      return s:match("%.png$") or s:match("%.jpe?g$") or s:match("%.gif$")
        or s:match("%.webp$") or s:match("%.bmp$") or s:match("%.svg$")
    end
    vim.paste = function(lines, phase)
      if phase == -1 and #lines == 1 and looks_like_image(lines[1]) then
        lines = { (lines[1]:gsub("\\(%s)", "%1")) }
      end
      return img_clip_paste(lines, phase)
    end
  end,
}
