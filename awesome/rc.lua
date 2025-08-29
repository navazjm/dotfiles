pcall(require, "luarocks.loader")
local gears = require("gears") -- provides utility functions
local awful = require("awful") -- core window management functions
require("awful.autofocus")
local wibox = require("wibox") -- widgets and UI
local beautiful = require("beautiful") -- themeing system
local naughty = require("naughty") -- notifications
local lain = require("lain") -- window management layout
local freedesktop = require("freedesktop") -- menu
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

local xresources = require("beautiful.xresources")
xresources.set_dpi(130) -- Or 110, 120, etc., based on your screen

local opacity_val = 0.95

-- Start picom with backend
awful.spawn.with_shell("picom --backend xrender")

-------------------------------------------------------------------------------
-- Error handling --
-------------------------------------------------------------------------------

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then
            return
        end

        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })

        in_error = false
    end)
end

-------------------------------------------------------------------------------
-- Autostart windowless processes --
-------------------------------------------------------------------------------

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "urxvtd", "unclutter -root", "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"}) -- comma-separated entries

-------------------------------------------------------------------------------
-- Variable definitions --
-------------------------------------------------------------------------------

local modkey = "Mod4"
local altkey = "Mod1"
local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local editor = os.getenv("EDITOR") or "nvim"
local browser = "firefox-dev"
local browser_personal = "firefox"
local audio = "pavucontrol"
local fileExp = "pcmanfm ~"
local steam = "steam"
local vlc = "vlc"
local discord = "Discord"
local obs = "obs"
local kdenlive = "kdenlive"
local terminal = "st"
local st_command = terminal .. " -c st-256color"
local image_editor = "gimp"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

-- add click events to taglist
awful.util.taglist_buttons = mytable.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

-- add click events to tasklist
awful.util.tasklist_buttons = mytable.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

beautiful.init(string.format("%s/.config/awesome/theme/theme.lua", os.getenv("HOME")))

-------------------------------------------------------------------------------
-- Menu --
-------------------------------------------------------------------------------

-- Create a launcher widget and a main menu
local myawesomemenu = {
    {
        "Hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "Manual", string.format("%s -e man awesome", terminal) },
    { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    {
        "Lock Screen",
        function()
            awful.spawn.with_shell(string.format("%s/.local/bin/screenlock", os.getenv("HOME")))
        end,
    },
    { "Restart", awesome.restart },
    {
        "Quit",
        function()
            awesome.quit()
        end,
    },
}

awful.util.mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    },
})

-- Hide the menu when the mouse leaves it
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)

-------------------------------------------------------------------------------
-- Screen --
-------------------------------------------------------------------------------

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
end)

-------------------------------------------------------------------------------
-- Mouse bindings --
-------------------------------------------------------------------------------

root.buttons(mytable.join(
    awful.button({}, 3, function()
        awful.util.mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-------------------------------------------------------------------------------
-- Key bindings --
-------------------------------------------------------------------------------

globalkeys = mytable.join(
    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "h", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ modkey, "Control" }, "l", function()
        awful.spawn.with_shell(string.format("%s/.local/bin/screenlock", os.getenv("HOME")))
    end, { description = "lock screen", group = "awesome" }),

    -- Default client focus
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),
    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),

    -- quick resize of windows
    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),

    -- change window layout
    awful.key({ modkey, "Control" }, "n", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Control", "Shift" }, "n", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    -- ALSA volume control
    awful.key({ altkey }, "Up", function()
        os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
        beautiful.volume.update()
    end, { description = "volume up", group = "hotkeys" }),
    awful.key({ altkey }, "Down", function()
        os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
        beautiful.volume.update()
    end, { description = "volume down", group = "hotkeys" }),
    awful.key({ altkey }, "m", function()
        os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
        beautiful.volume.update()
    end, { description = "toggle mute", group = "hotkeys" }),
    awful.key({ altkey, "Shift" }, "m", function()
        os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
        beautiful.volume.update()
    end, { description = "volume 100%", group = "hotkeys" }),
    awful.key({ altkey, "Control" }, "m", function()
        os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
        beautiful.volume.update()
    end, { description = "volume 0%", group = "hotkeys" }),

    -- Capture screenshot of area selection, equivalent to windows keybinding
    awful.key({ modkey, "Shift" }, "s", function()
        awful.spawn.with_shell(
            "scrot -s ~/pictures/screenshots/%d-%m-%Y_%H%M%S.png -e 'xdg-open ~/pictures/screenshots'"
        )
    end, { description = "Capture screenshot", group = "hotkeys" }),

    -- User programs
    awful.key({ modkey }, "b", function()
        awful.spawn(browser)
    end, { description = "run Browser", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "b", function()
        awful.spawn(browser_personal)
    end, { description = "run Personal Browser", group = "launcher" }),
    awful.key({ modkey }, "a", function()
        awful.spawn(audio)
    end, { description = "run Pavucontrol", group = "launcher" }),
    awful.key({ modkey }, "r", function()
        awful.spawn(obs)
    end, { description = "run OBS", group = "launcher" }),
    awful.key({ modkey }, "f", function()
        awful.spawn.with_shell(fileExp)
    end, { description = "run Pcmanfm", group = "launcher" }),
    awful.key({ modkey }, "t", function()
        awful.spawn(st_command)
    end, { description = "run Terminal", group = "launcher" }),
    awful.key({ modkey }, "s", function()
        awful.spawn(steam)
    end, { description = "run Steam", group = "launcher" }),
    awful.key({ modkey }, "v", function()
        awful.spawn(vlc)
    end, { description = "run VLC", group = "launcher" }),
    awful.key({ modkey }, "d", function()
        awful.spawn(discord)
    end, { description = "run Discord", group = "launcher" }),
    awful.key({ modkey }, "e", function()
        awful.spawn.with_shell(kdenlive)
    end, { description = "run Kdenlive", group = "launcher" }),
    awful.key({ modkey }, "i", function()
        awful.spawn(image_editor)
    end, { description = "run " .. image_editor, group = "launcher" }),

    -- Prompt
    awful.key({ altkey, "Shift" }, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "awesome" }),

    -- lua prompt
    awful.key({ altkey, "Shift" }, "x", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "awesome" }),

    -- rofi
    awful.key({ modkey }, "space", function ()
            os.execute("rofi -show run")
    end, {description = "show rofi", group = "launcher"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = mytable.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" })
    )
end

clientkeys = mytable.join(
    -- close client (window)
    awful.key({ modkey }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" })
)

clientbuttons = mytable.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-------------------------------------------------------------------------------
-- Rules --
-------------------------------------------------------------------------------

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
        },
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true },
    },

    -- transparent windows
    { rule = { class =  "st-256color" }, properties = { opacity = opacity_val } },
    { rule = { class = "firefox-dev" }, properties = { opacity = opacity_val } },
    { rule = { class = "discord" }, properties = { opacity = opacity_val } },
    { rule = { class = "Pcmanfm" }, properties = { opacity = opacity_val } },

    -- fix issue with steam being "frozen" when navigating between tags
    {
        rule = { class = "Steam" },
        properties = {
            floating = false,
            maximized = false,
            focus = true,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }
}

-------------------------------------------------------------------------------
-- Signals --
-------------------------------------------------------------------------------

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 16 }):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-------------------------------------------------------------------------------
-- On initial launch, or restart if no instances are found, open st in tags 1
-- and firefox in tags 2.
-------------------------------------------------------------------------------

local function st_matcher(c)
    return c.class == "st-256color"
end

if awesome.startup then
    awful.spawn.single_instance(st_command, {
        tag = screen.primary.tags[1],
        class = "st-256color",
    }, st_matcher, "autostart-st")

    awful.spawn.single_instance(browser, {
        tag = screen.primary.tags[2],
        class = browser,
    }, nil, "autostart-firefox")
end
