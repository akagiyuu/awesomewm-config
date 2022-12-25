local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local capi = {
    client = client,
    mouse = mouse,
}
local _client = {}

local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

--- resize client
---@param direction
---|"'up'"
---|"'down'"
---|"'left'"
---|"'right'"
---@param c any client
_client._resize_float = function(direction, c)
    if direction == "up" then
        c:relative_move(0, 0, 0, -floating_resize_amount)
    elseif direction == "down" then
        c:relative_move(0, 0, 0, floating_resize_amount)
    elseif direction == "left" then
        c:relative_move(0, 0, -floating_resize_amount, 0)
    elseif direction == "right" then
        c:relative_move(0, 0, floating_resize_amount, 0)
    end
end

--- resize client
---@param direction
---|"'up'"
---|"'down'"
---|"'left'"
---|"'right'"
_client._resize_tile = function(direction)
    if direction == "up" then
        awful.client.incwfact(-tiling_resize_factor)
    elseif direction == "down" then
        awful.client.incwfact(tiling_resize_factor)
    elseif direction == "left" then
        awful.tag.incmwfact(-tiling_resize_factor)
    elseif direction == "right" then
        awful.tag.incmwfact(tiling_resize_factor)
    end
end

--- resize client
---@param direction
---|"'up'"
---|"'down'"
---|"'left'"
---|"'right'"
---@param c any client
function _client:resize(direction, c)
    if c and c.floating or awful.layout.get(capi.mouse.screen) == awful.layout.suit.floating then
        self._resize_float(c, direction)
        return
    end

    if awful.layout.get(capi.mouse.screen) ~= awful.layout.suit.floating then
        self._resize_tile(direction)
    end
end

return _client
