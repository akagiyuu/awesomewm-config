local dpi = require("beautiful").xresources.apply_dpi
local wibox = require("wibox")
local clickable_container = require('container.clickable')
local beautiful = require("beautiful")
local helper = require('helper')

local create_button = function(name, icon, bg_color, callback)
    local item = wibox.widget {
        {
            {
                {
                    {
                        {
                            image = icon,
                            resize = true,
                            forced_height = dpi(30),
                            widget = wibox.widget.imagebox
                        },
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    {
                        {
                            text = name,
                            font = beautiful.font_name .. " Bold 30",
                            widget = wibox.widget.textbox
                        },
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    widget = wibox.layout.fixed.horizontal
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            fg = "#212121",
            bg = bg_color,
            shape = helper.ui.rounded_rectangle(10),
            widget = wibox.container.background,
            id = 'background'
        },
        spacing = dpi(0),
        layout = wibox.layout.align.vertical
    }

    item = clickable_container(item)
    item:connect_signal("button::release", function() callback() end)

    return item
end
return create_button
