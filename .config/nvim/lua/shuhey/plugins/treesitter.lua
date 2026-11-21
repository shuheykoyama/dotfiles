return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The main branch does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "mks-h/treesitter-autoinstall.nvim", lazy = false },
    },
    config = function()
      local TS = require("nvim-treesitter")

      if vim.fn.has("win32") == 1 and vim.fn.executable("cl.exe") == 0 then
        vim.env.CC = "gcc"
      end

      local ensure_installed = {
        "astro",
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "diff",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nu",
        "objc",
        "php",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "svelte",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      }

      local function install_parsers()
        TS.install(ensure_installed)
      end

      -- Wait for mason-tool-installer to finish before compiling parsers
      if vim.fn.executable("tree-sitter") == 1 then
        install_parsers()
      else
        vim.api.nvim_create_autocmd("User", {
          pattern = "MasonToolsUpdateCompleted",
          once = true,
          callback = install_parsers,
        })
      end

      require("treesitter-autoinstall").setup()

      -- MDX has no parser of its own; render it with the Markdown one.
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")

      local treesitter_group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = treesitter_group,
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end

          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
