local awful = require('awful')
local capi = { awesome = awesome }

local _volume = {}

---Change volume by percent
---@param percent number volume to add
_volume.change = function(percent)
    capi.awesome.emit_signal('signal::volume', percent)
    capi.awesome.emit_signal('volume::changed')
    awful.spawn(string.format('pamixer -%s %s', percent < 0 and 'd' or 'i', math.abs(percent)))
end

---Get current volume
---@return number
_volume.get = function()
    local volume
    awful.spawn('pamixer --get-volume', {}, function(stdout)
        volume = tonumber(stdout) or 0
    end)

    return volume
end

_volume.mute = function()
    awful.util.spawn('pamixer -t')
end

return _volume
