local status_ok, tabby = pcall(require, "tabby.tabline")
if not status_ok then
	return
end

tabby.use_preset("active_wins_at_tail", {
	theme = {
		fill = "TabLineFill",
		-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
		head = "TabLine",
		-- current_tab = 'TabLineSel',
		current_tab = { fg = "#F8FBF6", bg = "#896a98", style = "italic" },
		tab = "TabLine",
		win = "TabLine",
		tail = "TabLine",
	},
	nerdfont = true, -- whether use nerdfont
	buf_name = {
		mode = "relative",
	},
})
