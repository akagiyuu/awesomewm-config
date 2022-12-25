local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local _misc = {}

_misc.send_key = function(client, key)
    awful.spawn.with_shell("xdotool key --window " .. tostring(client.window) .. " " .. key)
end
_misc.send_click = function(client, click)
    awful.spawn.with_shell("xdotool click " .. click)
end

_misc.toggle_wibar = function()
    local wibar = awful.screen.focused().wibar
    wibar.visible = not wibar.visible
end

_misc.rounded_rectangle = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
end


return _misc
