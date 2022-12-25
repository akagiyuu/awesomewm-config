local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local clock = wibox.widget.textclock('<span font="' .. beautiful.font .. '">%H:%M | %a %d %b</span>')
local clock_icon = require('widget.base.textbox') {
    text = ' ',
    type = 'icon',
}


local clock_widget = wibox.widget {
    wibox.widget {
        clock_icon,
        fg = colors.brightmagenta,
        widget = wibox.container.background
    },
    wibox.widget {
        clock,
        fg = colors.brightmagenta,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

local calendar = require("widget.calendar") {
    theme = 'dark',
    start_sunday = true,
    radius = beautiful.corner_radius,
    previous_month_button = 3,
    next_month_button = 1,
}

clock_widget:connect_signal("mouse::enter", function() calendar.show() end)


return clock_widget
