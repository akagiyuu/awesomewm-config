local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

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
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius) end,
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

