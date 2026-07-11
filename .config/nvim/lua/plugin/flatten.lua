---@type LazySpec
return {
  "willothy/flatten.nvim",
  -- Eager + high priority so flatten runs first, minimizing latency when a
  -- guest nvim (opened from a terminal / wezterm / kitty) forwards to the host.
  -- This is the upstream-recommended loading strategy.
  lazy = false,
  priority = 1001,
  -- Required: flatten activates only via setup(). Without this it is inert.
  config = true,
}
