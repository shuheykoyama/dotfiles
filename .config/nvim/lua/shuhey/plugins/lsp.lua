return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "tree-sitter-cli",
        "lua-language-server",
        "prettier",
        "prettierd",
        "selene",
        "shellcheck",
        "shfmt",
        "stylua",
        "eslint-lsp",
        "oxlint",
        "oxfmt",
        "tailwindcss-language-server",
        "vtsls",
        "copilot-language-server",
        "rust-analyzer",
        -- languages kept from the previous setup
        "html-lsp",
        "superhtml",
        "svelte-language-server",
        "astro-language-server",
        "rumdl",
        "pyrefly",
        "ruff",
        "bash-language-server",
        "clangd",
        "clang-format",
        "sqruff",
        "postgres-language-server",
        "jdtls",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- mason must be set up before any server starts so its bin directory is on PATH.
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      local capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
      })

      vim.lsp.enable({
        "eslint",
        "oxlint",
        "lua_ls",
        "cssls",
        "vtsls",
        "tailwindcss",
        "glsl_analyzer",
        -- rust_analyzer is started by rustaceanvim, jdtls by nvim-jdtls
        "html",
        "superhtml",
        "svelte",
        "astro",
        "pyrefly",
        "ruff",
        "rumdl",
        "bashls",
        "fish_lsp",
        "nushell",
        "nu_lint",
        "clangd",
        "sourcekit",
        "postgres_lsp",
        "sqruff",
      })
    end,
  },

  -- lazydev: lua-only (configures lua_ls library).
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = "rust",
    ---@type rustaceanvim.Opts
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = opts
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    opts = function()
      local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

      return {
        cmd = {
          vim.fn.exepath("jdtls"),
          string.format("--jvm-arg=-javaagent:%s", lombok_jar),
        },

        root_dir = function(fname)
          return vim.fs.root(fname, {
            "build.gradle",
            "build.gradle.kts",
            "pom.xml",
            "settings.gradle",
            "settings.gradle.kts",
            ".git",
          }) or vim.fn.getcwd()
        end,

        -- Per-project workspace isolation
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        settings = {
          java = {
            inlayHints = {
              parameterNames = { enabled = "all" },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local function full_cmd(o)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = o.root_dir(fname)
        local project_name = o.project_name(root_dir)
        local cmd = vim.deepcopy(o.cmd)
        if project_name then
          vim.list_extend(cmd, {
            "-configuration",
            o.jdtls_config_dir(project_name),
            "-data",
            o.jdtls_workspace_dir(project_name),
          })
        end
        return cmd
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        local config = {
          cmd = full_cmd(opts),
          root_dir = opts.root_dir(fname),
          settings = opts.settings,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        }
        require("jdtls").start_or_attach(config)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
      })

      -- Attach immediately for the first buffer (ft event already fired)
      attach_jdtls()
    end,
  },
}
