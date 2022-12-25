local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local _ui = {}

_ui.rounded_rectangle = function(border_radius)
    border_radius = dpi(border_radius or beautiful.border_radius)

    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, border_radius)
    end
end

_ui.colorize_text = function(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

return _ui
