local wibox      = require("wibox")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local helper     = require('helper')

local bar_element_container = function(widget, id)
    id = id or 'widget'
    local container = wibox.widget
    {
        widget,
        top = dpi(4),
        bottom = dpi(4),
        left = dpi(4),
        right = dpi(4),
        widget = wibox.container.margin
    }
    local box = wibox.widget {
        {
            container,
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        bg = colors.container,
        shape = helper.misc.rounded_rectangle,
        widget = wibox.container.background
    }
    return wibox.widget {
        box,
        id = id,
        top = dpi(4),
        bottom = dpi(4),
        right = dpi(2),
        left = dpi(2),
        widget = wibox.container.margin
    }
end

return bar_element_container
