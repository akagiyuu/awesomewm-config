local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local rubato = require('module.rubato')

local animation
local temprature = wibox.widget {
    {
        id = 'text',
        font = beautiful.font,
        widget = wibox.widget.textbox,
    },
    width = 100,
    widget = wibox.container.constraint,
}
animation = rubato.timed {
    intro = 0.05,
    duration = 0.3,
    easing = {
        F = 1 / 3,
        easing = function(t) return t * t end
    },
    subscribed = function(value) temprature.width = value end
}

watch('bash -c "sensors | awk \'/Core 0/ {print substr($3, 2) }\'"', 30, function(_, stdout)
    temprature:get_children_by_id('text')[1].text = stdout
end)

local temprature_icon = wibox.widget {
    text = '',
    font = beautiful.icon_font,
    widget = wibox.widget.textbox,
}
local temprature_widget = wibox.widget {
    {
        temprature_icon,
        fg = colors.brightred,
        widget = wibox.container.background
    },
    {
        temprature,
        fg = colors.brightred,
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
}

temprature_widget:connect_signal("mouse::enter", function() animation.target = dpi(50) end)
temprature_widget:connect_signal("mouse::leave", function() animation.target = 0 end)

return temprature_widget
