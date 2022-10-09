-------------------------------------------------
-- Net Speed Widget for Awesome Window Manager
-- Shows current upload/download speed
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/net-speed-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local watch = require("awful.widget.watch")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local rubato = require("modules.rubato")

local net_speed_widget = {}

local function convert_to_h(bytes)
    local speed
    local dim
    local bits = bytes * 8
    if bits < 1000 then
        speed = bits
        dim = 'b/s'
    elseif bits < 1000000 then
        speed = bits / 1000
        dim = 'kb/s'
    elseif bits < 1000000000 then
        speed = bits / 1000000
        dim = 'mb/s'
    elseif bits < 1000000000000 then
        speed = bits / 1000000000
        dim = 'gb/s'
    else
        speed = tonumber(bits)
        dim = 'b/s'
    end
    return math.floor(speed + 0.5) .. dim
end

local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

local function worker(user_args)

    local args = user_args or {}

    local interface = args.interface or '*'
    local timeout = args.timeout or 10

    -- make sure these are not shared across different worker/widgets (e.g. two monitors)
    -- otherwise the speed will be randomly split among the worker in each monitor
    local prev_rx = 0
    local prev_tx = 0
    local update_widget = function(widget, stdout)

        local cur_vals = split(stdout, '\r\n')

        local cur_rx = 0
        local cur_tx = 0

        for i, v in ipairs(cur_vals) do
            if i % 2 == 1 then cur_rx = cur_rx + v end
            if i % 2 == 0 then cur_tx = cur_tx + v end
        end

        local speed_rx = (cur_rx - prev_rx) / timeout
        local speed_tx = (cur_tx - prev_tx) / timeout

        widget:set_net_speed(convert_to_h(speed_rx), convert_to_h(speed_tx))

        prev_rx = cur_rx
        prev_tx = cur_tx
    end

    local animation

    local speed = wibox.widget {
        {
            {
                id = 'rx_speed',
                align = 'right',
                widget = wibox.widget.textbox
            },
            {
                markup = [[<span foreground=']] .. colors.red .. [[' style='normal'> 󰁅 </span>]],
                widget = wibox.widget.textbox
            },
            {
                markup = [[<span foreground=']] .. colors.green .. [[' style='normal'> 󰁝 </span>]],
                widget = wibox.widget.textbox
            },
            {
                id = 'tx_speed',
                align = 'left',
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.horizontal,

        },
        id = 'speed',
        width = 0,
        widget = wibox.container.constraint,
        set_net_speed = function(self, rx_speed, tx_speed)
            self:get_children_by_id('rx_speed')[1]:set_text(' ' .. rx_speed)
            self:get_children_by_id('tx_speed')[1]:set_text(tx_speed)
        end,
    }

    animation = rubato.timed {
        intro = 0.1,
        duration = 0.5,
        easing = {
            F = 1 / 3,
            easing = function(t) return t * t end
        },
        subscribed = function(value) speed.width = value end
    }

    watch(
        string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], interface),
        timeout,
        update_widget,
        speed
    )

    net_speed_widget = wibox.widget {
        {
            markup = [[<span foreground="#dfdfdf" style='normal'> 󰖩 </span>]],
            widget = wibox.widget.textbox,
        },
        speed,
        layout = wibox.layout.fixed.horizontal,
    }
    net_speed_widget:connect_signal("mouse::enter", function(_, _, _, _) animation.target = dpi(150) end)
    net_speed_widget:connect_signal("mouse::leave", function(_, _, _, _) animation.target = 0 end)

    return net_speed_widget
end

return setmetatable(net_speed_widget, { __call = function(_, ...) return worker(...) end })
