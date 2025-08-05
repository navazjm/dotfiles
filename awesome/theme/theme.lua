--[[

     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/theme"
theme.wallpaper = theme.dir .. "/wall.png"
theme.font = "Inter monospace 9"
theme.fg_normal = "#DDDDFF"
theme.fg_focus = "#8CD0D3"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#1A1A1A"
theme.bg_focus = "#313131"
theme.bg_urgent = "#1A1A1A"
theme.border_width = dpi(1)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#7F7F7F"
theme.border_marked = "#CC9393"
theme.tasklist_bg_focus = "#1A1A1A"
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus
theme.menu_height = dpi(16)
theme.menu_width = dpi(140)
theme.menu_submenu_icon = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile = theme.dir .. "/icons/tile.png"
theme.layout_tileleft = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv = theme.dir .. "/icons/fairv.png"
theme.layout_fairh = theme.dir .. "/icons/fairh.png"
theme.layout_spiral = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle = theme.dir .. "/icons/dwindle.png"
theme.layout_max = theme.dir .. "/icons/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/magnifier.png"
theme.layout_floating = theme.dir .. "/icons/floating.png"
theme.widget_ac = theme.dir .. "/icons/ac.png"
theme.widget_battery = theme.dir .. "/icons/battery.png"
theme.widget_battery_low = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem = theme.dir .. "/icons/mem.png"
theme.widget_cpu = theme.dir .. "/icons/cpu.png"
theme.widget_temp = theme.dir .. "/icons/temp.png"
theme.widget_net = theme.dir .. "/icons/net.png"
theme.widget_net_wired = theme.dir .. "/icons/net_wired.png"
theme.widget_hdd = theme.dir .. "/icons/hdd.png"
theme.widget_music = theme.dir .. "/icons/note.png"
theme.widget_music_on = theme.dir .. "/icons/note_on.png"
theme.widget_vol = theme.dir .. "/icons/vol.png"
theme.widget_vol_low = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail = theme.dir .. "/icons/mail.png"
theme.widget_mail_on = theme.dir .. "/icons/mail_on.png"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.useless_gap = dpi(3)
theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

local keyboardlayout = awful.widget.keyboardlayout:new()

-- Textclock
local clock = awful.widget.watch("date +'%Y-%m-%d %H:%M:%S'", 1, function(widget, stdout)
	widget:set_markup(" " .. markup.font(theme.font, stdout))
end)

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
	timeout = 5, -- Update every 5 seconds instead of default 2
	settings = function()
		local used = tonumber(mem_now.used)
		local display_text

		if used >= 1024 then
			-- Convert MB to GB (1024 MB = 1 GB)
			display_text = string.format("%.1fGB", used / 1024)
		else
			display_text = used .. "MB"
		end

		widget:set_markup(markup.font(theme.font, string.format(" %6s ", display_text)))
	end,
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
	settings = function()
		widget:set_markup(markup.font(theme.font, " " .. string.format("%02d", cpu_now.usage) .. "% "))
	end,
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
	tempfile = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon3/temp1_input",
	settings = function()
		local temp_num = tonumber(coretemp_now)
		local color = "#DDDDFF" -- default white

		if temp_num then
			if temp_num > 80 then
				color = "#ff0000" -- red for hot
			elseif temp_num > 70 then
				color = "#ffaa00" -- orange for warm
			elseif temp_num > 60 then
				color = "#ffff00" -- yellow for moderate
			end
		end

		widget:set_markup(markup.font(theme.font, " <span color='" .. color .. "'>" .. coretemp_now .. "°C</span> "))
	end,
})

-- / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({
	notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = theme.font },
	settings = function()
		local used_percentage = fs_now["/"].percentage
		local color = "#DDDDFF"

		-- Color coding based on disk usage
		if used_percentage >= 90 then
			color = "#FF0000" -- red
		elseif used_percentage >= 80 then
			color = "#FFAA00" -- orange
		elseif used_percentage >= 70 then
			color = "#FFFF00" -- yellow
		end

		widget:set_markup(markup.font(theme.font, " <span color='" .. color .. "'>" .. used_percentage .. "%</span> "))
	end,
})

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
	settings = function()
		if volume_now.status == "off" then
			volicon:set_image(theme.widget_vol_mute)
		elseif tonumber(volume_now.level) == 0 then
			volicon:set_image(theme.widget_vol_no)
		elseif tonumber(volume_now.level) <= 50 then
			volicon:set_image(theme.widget_vol_low)
		else
			volicon:set_image(theme.widget_vol)
		end

		widget:set_markup(markup.font(theme.font, " " .. string.format("%02d", volume_now.level) .. "% "))
	end,
})
theme.volume.widget:buttons(awful.util.table.join(
	awful.button({}, 4, function()
		awful.util.spawn("amixer set Master 1%+")
		theme.volume.update()
	end),
	awful.button({}, 5, function()
		awful.util.spawn("amixer set Master 1%-")
		theme.volume.update()
	end)
))

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
	settings = function()
		-- Check active interface name
		awful.spawn.easy_async_with_shell("ip route show default | head -1 | awk '{print $5}'", function(stdout)
			local interface = stdout:gsub("\n", "")
			if interface:match("^wl") or interface:match("^wlan") then
				neticon:set_image(theme.widget_net) -- WiFi icon
				widget:set_markup(markup.font(theme.font, ""))
			elseif interface:match("^e") then -- eth, enp, eno
				neticon:set_image(theme.widget_net_wired) -- Wired icon
				widget:set_markup(markup.font(theme.font, ""))
			else
				neticon:set_image(nil) -- Clear the icon
				widget:set_markup(markup.font(theme.font, " <span color='#FF0000'>❌ Offline</span> "))
			end
		end)
	end,
})
-- Function to format bytes with appropriate units
local function format_speed(kb_per_sec)
	if kb_per_sec >= 1024 * 1024 then
		return string.format("%.1f GB/s", kb_per_sec / (1024 * 1024))
	elseif kb_per_sec >= 1024 then
		return string.format("%.1f MB/s", kb_per_sec / 1024)
	else
		return string.format("%.1f KB/s", kb_per_sec)
	end
end

-- Tooltip showing network speeds
local net_tooltip = awful.tooltip({
	objects = { neticon },
	timer_function = function()
		local tooltip_text = "Up: "
			.. format_speed(tonumber(net_now.sent))
			.. " | Down: "
			.. format_speed(tonumber(net_now.received))
		return tooltip_text
	end,
	fg = theme.fg_normal,
	bg = theme.bg_normal,
	font = theme.font,
})

-- Separators
local spr = wibox.widget.textbox(" ")
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

function theme.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({ app = awful.util.terminal })

	-- If wallpaper is a function, call it with the screen
	local wallpaper = theme.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(my_table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 2, function()
			awful.layout.set(awful.layout.layouts[1])
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

	-- Create the wibox
	s.mywibox =
		awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			--spr,
			s.mytaglist,
			s.mypromptbox,
			spr,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			arrl_ld,
			wibox.container.background(keyboardlayout, theme.bg_focus),
			arrl_dl,
			volicon,
			theme.volume.widget,
			arrl_ld,
			wibox.container.background(memicon, theme.bg_focus),
			wibox.container.background(mem.widget, theme.bg_focus),
			arrl_dl,
			cpuicon,
			cpu.widget,
			arrl_ld,
			wibox.container.background(tempicon, theme.bg_focus),
			wibox.container.background(temp.widget, theme.bg_focus),
			arrl_dl,
			fsicon,
			theme.fs.widget,
			arrl_ld,
			wibox.container.background(neticon, theme.bg_focus),
			wibox.container.background(net.widget, theme.bg_focus),
			arrl_dl,
			clock,
			spr,
			arrl_ld,
			wibox.container.background(s.mylayoutbox, theme.bg_focus),
		},
	})
end

return theme
