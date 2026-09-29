-- Follow the active Hexarchy system theme with a single colorscheme plugin.
-- aether.nvim takes its palette from the current theme's colors.toml, so there
-- is no per-theme plugin to install. The palette is re-read on a timer whenever
-- `hexarchy theme set <name>` swaps the current theme state directory, which
-- makes a running nvim adapt live without a restart.
local colors_file = os.getenv("HOME") .. "/.local/state/hexarchy/current/theme/colors.toml"

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

local function parse_colors(content)
	local colors = {}
	for key, value in content:gmatch("(%w+)%s*=%s*\"([#%x]+)\"") do
		colors[key] = value
	end
	return colors
end

-- Same expansion Hexarchy applies when rendering its templates, so nvim gets
-- exactly the palette every other program on the desktop sees.
local function theme_colors(c)
	return {
		bg = c.background,
		dark_bg = c.dark_background,
		darker_bg = c.darker_background,
		lighter_bg = c.lighter_background,
		fg = c.foreground,
		dark_fg = c.dark_foreground,
		light_fg = c.light_foreground,
		bright_fg = c.bright_foreground,
		muted = c.muted,
		red = c.red,
		yellow = c.yellow,
		orange = c.orange,
		green = c.green,
		cyan = c.cyan,
		blue = c.blue,
		magenta = c.magenta,
		brown = c.brown,
		bright_red = c.bright_red,
		bright_yellow = c.bright_yellow,
		bright_green = c.bright_green,
		bright_cyan = c.bright_cyan,
		bright_blue = c.bright_blue,
		bright_magenta = c.bright_magenta,
		accent = c.accent,
		cursor = c.bright_foreground,
		foreground = c.foreground,
		background = c.background,
		selection = c.selection,
		selection_foreground = c.bright_foreground,
		selection_background = c.selection,
	}
end

local function apply()
	local content = read_file(colors_file)
	if not content then
		return false
	end
	local colors = theme_colors(parse_colors(content))
	require("aether").setup({ colors = colors })
	vim.cmd.colorscheme("aether")
	return true
end

-- Let the terminal's background opacity (kitty uses 0.85) show through, so the
-- editor is as transparent as the terminal around it.
local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"SignColumn",
	"CursorLine",
	"LineNr",
	"CursorLineNr",
	"FoldColumn",
	"MsgArea",
	"WinSeparator",
	"TelescopePromptNormal",
	"TelescopePromptBorder",
	"TelescopeResultsNormal",
	"TelescopeResultsBorder",
	"TelescopePreviewNormal",
	"TelescopePreviewBorder",
	"TelescopeSelection",
	"TelescopeSelectionCaret",
	"TelescopeMultiSelection",
	"TelescopePreviewLine",
	"TelescopePreviewMatch",
}

local function make_transparent()
	for _, group in ipairs(transparent_groups) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
		if ok and hl then
			vim.api.nvim_set_hl(0, group, { bg = "none" })
		end
	end
end

local function watch()
	local timer = vim.uv.new_timer()
	local last = read_file(colors_file)
	timer:start(2000, 2000, vim.schedule_wrap(function()
		local now = read_file(colors_file)
		if now and now ~= last then
			last = now
			apply()
		end
	end))
end

return {
	"bjarneo/aether.nvim",
	branch = "v3",
	priority = 1000,
	lazy = false,
	config = function()
		if apply() then
			watch()
		end
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = make_transparent,
		})
		make_transparent()
	end,
}