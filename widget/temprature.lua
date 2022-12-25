local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local rubato = require('module.rubato')

local temprature = wibox.widget {
    require('widget.base.text') {
        id = 'text',
        font = beautiful.font_name,
        color = colors.brightred,
        create_callback = function(self)
            watch('bash -c "sensors | awk \'/Core 0/ {print substr($3, 2) }\'"', 30, function(_, stdout)
                self.text = stdout
            end)
        end
    },
    width = 100,
    widget = wibox.container.constraint,
}


local animation = rubato.timed {
    intro = 0.05,
    duration = 0.3,
    easing = {
        F = 1 / 3,
        easing = function(t) return t * t end
    },
    subscribed = function(value) temprature.width = value end
}

local temprature_widget = wibox.widget {
    require('widget.base.text') {
        text = '',
        font = beautiful.icon_font,
        italic = false,
        color = colors.brightred,
    },
    layout = wibox.layout.fixed.horizontal
}

temprature_widget:connect_signal("mouse::enter", function() animation.target = dpi(50) end)
temprature_widget:connect_signal("mouse::leave", function() animation.target = 0 end)

return temprature_widget
