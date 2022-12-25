local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local clock_widget = wibox.widget {
    require('widget.base.text') {
        text = ' ',
        size = 14,
        font = beautiful.icon_font,
        italic = false,
        color = colors.brightmagenta,
    },
    {
        {
            font = beautiful.font,
            format = '%H:%M | %a %d %b',
            widget = wibox.widget.textclock
        },
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
