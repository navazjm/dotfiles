local status_ok, barbar = pcall(require, "barbar")
if not status_ok then
	return
end

vim.g.barbar_auto_setup = true -- disable auto-setup

barbar.setup({
	-- Set the filetypes which barbar will offset itself for
	sidebar_filetypes = {
		-- Use the default values: {event = 'BufWinLeave', text = nil}
		NvimTree = true,
	},
})
