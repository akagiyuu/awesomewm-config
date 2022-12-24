local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local vertival_titlebar = function(c)
    local buttons = {
        awful.button({}, 1, function()
            c:activate { context = "titlebar", action = "mouse_move" }
        end),
        awful.button({}, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
        end),
    }

    local titlebar = awful.titlebar(c, {
        size = dpi(30),
        position = 'left',
    })

    titlebar:setup {
        {
            {
                {
                    --awful.titlebar.widget.floatingbutton (c),
                    awful.titlebar.widget.closebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.minimizebutton(c),
                    --awful.titlebar.widget.stickybutton   (c),
                    --awful.titlebar.widget.ontopbutton    (c),
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                },
                {
                    buttons = buttons,
                    layout = wibox.layout.fixed.vertical,
                },
                {
                    buttons = buttons,
                    awful.titlebar.widget.iconwidget(c),
                    layout = wibox.layout.fixed.vertical,
                },
                layout = wibox.layout.align.vertical,
            },
            margins = {
                top    = dpi(6),
                bottom = dpi(6),
                left   = dpi(6),
                right  = dpi(6)
            },
            widget = wibox.container.margin,
        },
        id = 'background_role',
        widget = wibox.container.background,
    }
end

client.connect_signal("request::titlebars", function(c) vertival_titlebar(c) end)
