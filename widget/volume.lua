local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require('module.rubato')

local volume_icon = require('widget.base.text') {
    id = "icon",
    text = '󰕾',
    font = beautiful.icon_font,
    italic = false,
    color = colors.brightcyan,
}

local volume_text = wibox.widget {
    require('widget.base.text') {
        id = "text",
        text = "  ",
        color = colors.brightcyan,
        font = beautiful.font,
    },
    width = 0,
    widget = wibox.container.constraint,
}
local animation = rubato.timed {
    intro = 0.05,
    duration = 0.3,
    subscribed = function(value) volume_text.width = value end
}

local volume_widget = wibox.widget {
    volume_icon,
    nil,
    volume_text,
    expand = "none",
    layout = wibox.layout.align.horizontal,
}
volume_widget:connect_signal("mouse::enter", function() animation.target = dpi(50) end)
volume_widget:connect_signal("mouse::leave", function() animation.target = 0 end)

local update = function()
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
        local value = tonumber(stdout)

        local icon = '󰕿'

        if value == 0 then
            icon = '󰝟'
        elseif value >= 75 then
            icon = '󰕾'
        elseif value >= 50 then
            icon = '󰖀'
        end

        volume_icon.text = icon
        volume_text:get_children_by_id('text')[1].text = ' ' .. value .. '% '
    end)
end

update()

awesome.connect_signal("signal::volume", function() update() end)

return volume_widget
