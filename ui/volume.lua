local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local rubato = require('module.rubato')

local offsetx = dpi(56)
local offsety = dpi(250)
local screen = awful.screen.focused()
local icon_dir = Paths.icon .. 'volume/'

local volume_icon = wibox.widget {
    widget = wibox.widget.imagebox
}

-- create the volume_adjust component
local volume_adjust = wibox {
    screen = awful.screen.focused(),
    x = screen.geometry.width - offsetx,
    y = (screen.geometry.height / 2) - (offsety / 2),
    width = dpi(40),
    height = offsety,
    visible = false,
    ontop = true,
    bg = colors.transparent
}

local volume_bar = wibox.widget {
    shape = gears.shape.rounded_bar,
    bar_height = 6,
    bar_color = colors.transparent,
    bar_active_color = beautiful.fg_focus,
    handle_shape = gears.shape.circle,
    handle_color = colors.brightwhite,
    handle_width = 10,
    value = 0,
    widget = wibox.widget.slider,
}
volume_bar:connect_signal('property::value', function(_, value)
    awful.spawn.with_shell('pamixer --set-volume ' .. value)
end)


volume_adjust:setup {
    layout = wibox.layout.align.vertical,
    {
        {
            volume_bar,
            margins = dpi(16),
            widget = wibox.container.margin
        },
        forced_height = offsety * 0.85,
        direction = 'east',
        layout = wibox.container.rotate
    },
    {
        volume_icon,
        left = dpi(12),
        right = dpi(12),
        widget = wibox.container.margin
    }
}

local change_value_animation = rubato.timed {
    intro = 0.05,
    duration = 0.2,
    easing = {
        F = 1 / 3,
        easing = function(t) return t * t end
    },
    subscribed = function(pos)
        volume_bar.value = pos
    end
}

local hide_volume_adjust = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function() volume_adjust.visible = false end
}
volume_adjust:connect_signal('mouse::enter', function()
    hide_volume_adjust:stop()
    volume_adjust.visible = true
end)
volume_adjust:connect_signal('mouse::leave', function()
    hide_volume_adjust:again()
end)

awesome.connect_signal('signal::volume',
    function()
        awful.spawn.easy_async_with_shell(
            'pamixer --get-volume',
            function(stdout)
                local volume_level = tonumber(stdout)
                change_value_animation.target = volume_level
                if (volume_level == 0) then
                    volume_icon:set_image(icon_dir .. 'volume_muted.svg')
                end
                if (volume_level >= 75) then
                    volume_icon:set_image(icon_dir .. 'volume_high.svg')
                    return
                end
                if (volume_level >= 50) then
                    volume_icon:set_image(icon_dir .. 'volume_medium.svg')
                    return
                end
                volume_icon:set_image(icon_dir .. 'volume_low.svg')
            end,
            false
        )

        -- make volume_adjust component visible
        if volume_adjust.visible then
            hide_volume_adjust:again()
        else
            volume_adjust.visible = true
            hide_volume_adjust:start()
        end
    end
)
