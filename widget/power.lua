local gears = require("gears")
local wibox = require("wibox")
local clickable_container = require('container.clickable')

-- Icon directory path
local icondir = Paths.icon .. "others/"

local power_widget = wibox.widget {
    {
        {
            {
                id = "icon",
                image = gears.color.recolor_image(icondir .. "power.svg", colors.red),
                widget = wibox.widget.imagebox,
                resize = false
            },
            id = "icon_layout",
            widget = wibox.container.place

        },
        id = "container",
        top = 2,
        down = 4,
        right = 0,
        left = 16,
        widget = wibox.container.margin
    },
    widget = wibox.container.background
}

power_widget = clickable_container(power_widget)

power_widget:connect_signal("button::release", function() awesome.emit_signal("module::powermenu:show") end)

return power_widget
