-- Imports ----------------------------------------+
                                                 --+
-- Standard awesome library                      --+
local gears = require("gears")                   --+
local awful = require("awful")                   --+
require("awful.autofocus")                       --+
-- Widget and layout library                     --+
local wibox = require("wibox")                   --+
-- Theme handling library                        --+
local beautiful = require("beautiful")           --+
-- Notification library                          --+
local naughty = require("naughty")               --+
-- For Volume Info in Wibar                      --+
local volume_control = require("volume-control") --+
---------------------------------------------------+

-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- Define Modkey & Default Terminal
terminal = "xfce4-terminal"
modkey   = "Mod4"

-- Layouts -------------------------+
awful.layout.layouts = {          --+
    awful.layout.suit.tile,       --+
    awful.layout.suit.max,        --+
    awful.layout.suit.tile.bottom --+
}                                 --+
------------------------------------+

-- Creating textclock widget
local mytextclock = wibox.widget {
    format = " %a  %-d/%-m  %-l:%M ",
    refresh = 60,
    widget = wibox.widget.textclock
}

-- Making taglist widget clickable
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey, "Shift" }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end))

-- Making tasklist widget clickable
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c) if c == client.focus then c.minimized = true
                                                       else c:emit_signal("request::activate", "tasklist", {raise = true}) end end))

-- Wibar Configuration ---------------------------------------------------------------------------------------------------------+
awful.screen.connect_for_each_screen(function(s)                                                                              --+
                                                                                                                              --+
    -- Each screen has its own tag table.                                                                                     --+
    awful.tag({ "Terminal", "TextEdit", "Browser", "NoteTaking", "Media", "Extras", "Scratchpad" }, s, awful.layout.layouts[1])
                                                                                                                              --+
    --Imagebox widget which will contain an icon indicating which layout we're using                                          --+
    s.mylayoutbox = awful.widget.layoutbox(s)                                                                                 --+
    s.mylayoutbox:buttons(gears.table.join(awful.button({ }, 1, function () awful.layout.inc( 1) end)))                       --+
                                                                                                                              --+
    --Taglist widget                                                                                                          --+
    s.mytaglist = awful.widget.taglist { screen  = s, filter  = awful.widget.taglist.filter.noempty, buttons = taglist_buttons }
                                                                                                                              --+
    --Tasklist widget                                                                                                         --+
    s.mytasklist = awful.widget.tasklist {                                                                                    --+
        screen  = s,                                                                                                          --+
        filter  = awful.widget.tasklist.filter.currenttags,                                                                   --+
        buttons = tasklist_buttons,                                                                                           --+
        style   = { bg_normal = beautiful.bg_normal .. "0", bg_focus = beautiful.bg_focus .. "0" } }                          --+
                                                                                                                              --+
    --Wibox                                                                                                                   --+
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = beautiful.bg_normal .. "CC", height = 19})                   --+
                                                                                                                              --+
    --Separators                                                                                                              --+
    s.myseparator1 = wibox.widget.separator { forced_width = 2, opacity = 0.0 } -- invisible sep                              --+
    s.myseparator2 = wibox.widget.separator { forced_width = 1, color = "#666666" } -- visible sep                            --+
                                                                                                                              --+
    -- Volume in Wibar                                                                                                        --+
    s.myvolicon = wibox.widget {text = " ♪ :", widget = wibox.widget.textbox}                                                  --+
    volumecfg = volume_control {device="pulse", font = "sans 9", step = '2%', lclick = "toggle", rclick = "pavucontrol", widget_text = {on = '% 3d%% ', off = ' M '}}
                                                                                                                              --+
    -- Add widgets to the wibox                                                                                               --+
    s.mywibox:setup { layout = wibox.layout.align.horizontal,                                                                 --+
        { layout = wibox.layout.fixed.horizontal, s.mylayoutbox, s.myseparator1, s.mytaglist, s.myseparator1, s.myseparator2 }, -- Left Wigdets
        s.mytasklist, -- Middle widget                                                                                        --+
        { layout = wibox.layout.fixed.horizontal, s.myseparator2, s.myseparator1, s.myvolicon, s.myseparator1, volumecfg.widget, s.myseparator1, s.myseparator2, s.myseparator1, mytextclock } -- Right Widgets
    }                                                                                                                         --+
end)                                                                                                                          --+
--------------------------------------------------------------------------------------------------------------------------------+

-- Key bindings -------------------------------------------------------------------------------------------------------------------------+
globalkeys = gears.table.join(                                                                                                         --+
                                                                                                                                       --+
    -- Launch Menubar                                                                                                                  --+
    awful.key({ modkey          }, "p",      function ()  awful.util.spawn("dmenu_run -i -p 'run:' -sb '#1D7C3A' -sf '#FFFFFF'") end), --+
                                                                                                                                       --+
    -- Lunch terminal                                                                                                                  --+
    awful.key({ modkey          }, "Return", function () awful.spawn(terminal) end),                                                   --+
                                                                                                                                       --+
    -- Launch Browser                                                                                                                  --+
    awful.key({ modkey          }, "b",      function ()  awful.util.spawn("librewolf") end),                                          --+
                                                                                                                                       --+
    -- Change focus to another window                                                                                                  --+
    awful.key({ modkey          }, "Right",  function () awful.client.focus.byidx( 1) end),                                            --+
    awful.key({ modkey          }, "Left",   function () awful.client.focus.byidx(-1) end),                                            --+
    awful.key({ modkey          }, "Tab",    function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end),
                                                                                                                                       --+
    -- Move focused window                                                                                                             --+
    awful.key({ modkey, "Shift" }, "Right",  function () awful.client.swap.byidx( 1) end),                                             --+
    awful.key({ modkey, "Shift" }, "Left",   function () awful.client.swap.byidx(-1) end),                                             --+
                                                                                                                                       --+
    -- Toggle layouts                                                                                                                  --+
    awful.key({ modkey          }, "t",      function () awful.layout.inc(1) end),                                                     --+
                                                                                                                                       --+
    -- Resize master window using keyboard                                                                                             --+
    awful.key({ modkey          }, "=",      function () awful.tag.incmwfact( 0.05) end),                                              --+
    awful.key({ modkey          }, "-",      function () awful.tag.incmwfact(-0.05) end),                                              --+
                                                                                                                                       --+
    -- Awesome Reconfigure                                                                                                             --+
    awful.key({ modkey          }, "q",      awesome.restart),                                                                         --+
                                                                                                                                       --+
    -- System Control                                                                                                                  --+
    awful.key({ modkey, "Shift" }, "q",      awesome.quit),                                                                            --+
    awful.key({ modkey, "Shift" }, "r",      function ()  awful.util.spawn("sudo reboot")   end),                                      --+
    awful.key({ modkey, "Shift" }, "s",      function ()  awful.util.spawn("sudo poweroff") end),                                      --+

    awful.key({                 }, "KP_Add",      function() volumecfg:up() end),
    awful.key({                 }, "KP_Subtract", function() volumecfg:down() end),
    awful.key({                 }, "KP_Enter",    function() volumecfg:toggle() end),
                                                                                                                                           --+
    -- Scratchpad                                                                                                                      --+
    awful.key({ modkey          }, "Next",  function () local screen = awful.screen.focused() local tag = screen.tags[7] if tag then awful.tag.viewtoggle(tag) end end),
    awful.key({ modkey          }, "Prior", function () if client.focus then local tag = client.focus.screen.tags[7] if tag then client.focus:move_to_tag(tag) end end end)
                                                                                                                                       --+
)                                                                                                                                      --+
                                                                                                                                       --+
clientkeys = gears.table.join(                                                                                                         --+
    -- Toggle fullscreen mode for focused window                                                                                       --+
    awful.key({ modkey          }, "f",      function (c) c.fullscreen = not c.fullscreen c:raise() end),                              --+
                                                                                                                                       --+
    -- Close the focused window                                                                                                        --+
    awful.key({ modkey, "Shift" }, "c",      function (c) c:kill() end),                                                               --+
                                                                                                                                       --+
    -- Toggle floating mode for focused window                                                                                         --+
    awful.key({ modkey          }, "space",  awful.client.floating.toggle))                                                            --+
-----------------------------------------------------------------------------------------------------------------------------------------+

-- Tag Manipulation --------------------------------------------------------------------------------------------------------------------------------------------+
for i = 1, 6 do                                                                                                                                               --+
  globalkeys = gears.table.join(globalkeys,                                                                                                                   --+
    -- View tag only.                                                                                                                                         --+
    awful.key({ modkey            }, "#" .. i + 9, function () local screen = awful.screen.focused() local tag = screen.tags[i] if tag then tag:view_only() end end),
    -- Toggle tag display.                                                                                                                                    --+
    awful.key({ modkey, "Control" }, "#" .. i + 9, function () local screen = awful.screen.focused() local tag = screen.tags[i] if tag then awful.tag.viewtoggle(tag) end end),
    -- Move client to tag.                                                                                                                                    --+
    awful.key({ modkey, "Shift"   }, "#" .. i + 9, function () if client.focus then local tag = client.focus.screen.tags[i] if tag then client.focus:move_to_tag(tag) end end end)
  )                                                                                                                                                           --+
end                                                                                                                                                           --+
----------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Mouse Bindings ---------------------------------------------------------------------------------------------------------------------------------+
clientbuttons = gears.table.join(                                                                                                                --+
    awful.button({        }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),                             --+
    awful.button({ modkey }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),  --+
    awful.button({ modkey }, 3, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end) --+
)                                                                                                                                                --+
---------------------------------------------------------------------------------------------------------------------------------------------------+

-- Set Keys ------------+
root.keys(globalkeys) --+
------------------------+

-- Rules to apply to new clients (through the "manage" signal) -------------------------------------------------------+
awful.rules.rules = {                                                                                               --+
    -- All clients will match this rule.                                                                            --+
    { rule = { },                                                                                                   --+
      properties = { border_width = 1,                                                                              --+
                     border_color = beautiful.border_color,                                                         --+
                     focus = awful.client.focus.filter,                                                             --+
                     raise = true,                                                                                  --+
                     keys = clientkeys,                                                                             --+
                     buttons = clientbuttons,                                                                       --+
                     screen = awful.screen.preferred,                                                               --+
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen} },                        --+
                                                                                                                    --+
    -- Floating clients.                                                                                            --+
    { rule_any = {                                                                                                  --+
        class = {"Pcmanfm", "Pavucontrol", "GParted", "Nitrogen", "KeePassXC"},                                     --+
        role = {"pop-up",},                                                                                         --+
        type = {"dialog"}                                                                                           --+
        }, properties = { floating = true }},                                                                       --+
                                                                                                                    --+
    -- Remove gap in bottom & right edges of xfce4-terminal                                                         --+
    { rule = {class = "Xfce4-terminal" }, properties = { size_hints_honor = false } },                              --+
                                                                                                                    --+                                                                                                                   --
	-- Window rules                                                                                                 --+
	{ rule_any = { class = {"lite-xl", "Geany"} }, properties = { tag = "TextEdit" } },                             --+
    { rule_any = { class = {"librewolf-default", "Firefox", "Brave-browser"} }, properties = { tag = "Browser" } }, --+
    { rule = { class = "Joplin" }, properties = { tag = "NoteTaking" } },                                           --+
    { rule = { class = "vlc" }, properties = { tag = "Media" } },                                                   --+
    { rule = { class = "KeePassXC" }, properties = { tag = "Extras" } }                                             --+
}                                                                                                                   --+
----------------------------------------------------------------------------------------------------------------------+

-- Signals function to execute when a new client appears -----------------------+
client.connect_signal("manage", function (c)                                  --+
    -- Set the windows at the slave,                                          --+
    -- i.e. put it at the end of others instead of setting it master.         --+
    if not awesome.startup then awful.client.setslave(c) end                  --+
                                                                              --+
    if awesome.startup                                                        --+
      and not c.size_hints.user_position                                      --+
      and not c.size_hints.program_position then                              --+
        -- Prevent clients from being unreachable after screen count changes. --+
        awful.placement.no_offscreen(c)                                       --+
    end                                                                       --+
end)                                                                          --+
--------------------------------------------------------------------------------+

-- Focus follows mouse --------------------------------------------------+
client.connect_signal("mouse::enter", function(c)                      --+
    c:emit_signal("request::activate", "mouse_enter", {raise = false}) --+
end)                                                                   --+
-------------------------------------------------------------------------+

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart applications -----------------------------------------------+
awful.spawn.with_shell("nitrogen --restore")                           --+
awful.spawn.with_shell("picom --config ~/.config/picom/picom.conf -b") --+
awful.spawn.with_shell("lxpolkit")                                     --+
-------------------------------------------------------------------------+
