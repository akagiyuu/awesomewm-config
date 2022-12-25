local awful = require('awful')
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

_misc.round = function(exact, quantum)
    local quant, frac = math.modf(exact / quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end

return _misc
