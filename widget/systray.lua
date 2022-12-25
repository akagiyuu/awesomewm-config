local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('container.clickable')
local beautiful = require('beautiful')
local rubato = require('module.rubato')

local arrow = require('widget.base.text') {
    id = 'icon',
    text = '',
    font = beautiful.icon_font,
}

local icons = wibox.widget {
    widget = wibox.container.constraint,
    strategy = "max",
    width = dpi(100),
    {
        {
            widget = wibox.widget.systray,
        },
        widget = wibox.container.margin,
        margins = dpi(10),
    },
}
local systray = wibox.widget {
    icons,
    {
        {
            {
                arrow,
                layout = wibox.layout.align.horizontal,
            },
            margins = dpi(7),
            widget = wibox.container.margin
        },
        widget = clickable_container
    },

    layout = wibox.layout.align.horizontal
}

local animation = rubato.timed {
    intro = 0.1,
    duration = 0.7,
    subscribed = function(width) icons.width = width end
}

systray.toggle = function()
    if icons.width == 0 then
        arrow.text = ''
        animation.target = 200
    else
        arrow.text = ''
        animation.target = 0
    end
end
systray:buttons(awful.button({}, 1, nil, systray.toggle))

return awful.widget.only_on_screen(systray, 'primary')
