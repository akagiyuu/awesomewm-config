local awful = require('awful')
local capi = { awesome = awesome }
local _system = {}

_system.suspend = function()
    awful.spawn("systemctl suspend")
    capi.awesome.emit_signal("module::powermenu:hide")
end

_system.logout = function()
    capi.awesome.quit()
end

_system.lock = function()
    awful.spawn(Paths.home .. "/.local/bin/lock")
    capi.awesome.emit_signal("module::powermenu:hide")
end

_system.shutdown = function()
    awful.spawn("shutdown")
    capi.awesome.emit_signal("module::powermenu:hide")
end

_system.reboot = function()
    awful.spawn("reboot")
    capi.awesome.emit_signal("module::powermenu:hide")
end


return _system
