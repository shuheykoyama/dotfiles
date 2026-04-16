vim.filetype.add({
  extension = {
    jax = "help",
    kbd = "lisp",
    mdx = "markdown",
    zon = "zig",
    astro = "astro",
  },
  filename = {
    [".envrc"] = "sh",
    ["tsconfig.json"] = "jsonc",
    ["mdx"] = "markdown",
    ["Podfile"] = "ruby",
  },
  pattern = {
    -- git
    [".*/%.git/config"] = "gitconfig",
    [".*/%.git/.*%.conf"] = "gitconfig",
    [".*/git/config"] = "gitconfig",
    [".*/git/.*%.conf"] = "gitconfig",
    [".*/%.git/ignore"] = "gitignore",
    [".*/git/ignore"] = "gitignore",
    -- ssh
    [".*/%.ssh/config"] = "sshconfig",
    [".*/%.ssh/.*%.conf"] = "sshconfig",
    [".*/ssh/.*%.conf"] = "sshconfig",
    -- env
    [".*/env.development"] = "sh",
    [".*/env.production"] = "sh",
    [".*/env.staging"] = "sh",
    [".*/env.local"] = "sh",
    [".*/%.env%.local"] = "sh",
    [".*/%.env%.development"] = "sh",
    [".*/%.env%.production"] = "sh",
    [".*/%.env%.staging"] = "sh",
    -- docker & compose
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["compose%.ya?ml"] = "yaml.docker-compose",
    [".*/Dockerfile.*"] = "dockerfile",
  },
})
