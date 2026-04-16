return {
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
}
