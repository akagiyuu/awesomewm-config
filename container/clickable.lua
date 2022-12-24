local wibox = require('wibox')
local beautiful = require("beautiful")
local rubato = require("module.rubato")

-- create widget instance
local create_widget = function(widget)
    local old_cursor, old_wibox

    local container = wibox.widget {
        widget = wibox.container.background,
        {
            widget = wibox.container.margin,
            top = beautiful.clickable_container_padding_y,
            bottom = beautiful.clickable_container_padding_y,
            left = beautiful.clickable_container_padding_x,
            right = beautiful.clickable_container_padding_x,
            widget,
        },
    }

    local container_opacity = rubato.timed {
        pos = 1,
        intro = 0.1,
        duration = 0.3,
        subscribed = function(pos)
            container.opacity = pos
        end
    }

    container:connect_signal('mouse::enter', function()
        container_opacity.target = 0.5
        local w = _G.mouse.current_wibox
        if w then
            old_cursor, old_wibox = w.cursor, w
            w.cursor = 'hand2'
        end
    end)
    container:connect_signal('mouse::leave', function()
        container_opacity.target = 1
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
    container:connect_signal('button::press', function()
        container_opacity.target = 0.7
    end)
    container:connect_signal('button::release', function()
        container_opacity.target = 0.5
    end)

    return container
end

return create_widget
