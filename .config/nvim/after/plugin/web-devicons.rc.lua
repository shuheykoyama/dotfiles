local status, icons = pcall(require, "nvim-web-devicons")
if not status then
	return
end

icons.setup({
	-- your personal icons can go here (to override)
	-- DebIcon will be appended to `name`
	override = {},
	-- globally enable default icons (default to false)
	-- will get overriden by `get_icons` option
	default = true,
})
