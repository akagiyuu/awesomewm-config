local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable_container')
local panel_width = dpi(350)

local init = function(screen)
    local panel = awful.popup {
        widget    = {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    forced_width = dpi(panel_width),
                    forced_height = (screen.geometry.height - dpi(100)),
                    spacing = dpi(10),
                    require('widget.notification_center')(screen)
                },
                margins = dpi(20),
                widget = wibox.container.margin
            },

            id           = 'info_center',
            border_width = dpi(1),
            border_color = beautiful.border_focus,
            widget       = wibox.container.background
        },
        screen    = screen,
        visible   = false,
        ontop     = true,
        bg        = colors.transparent,
        fg        = beautiful.fg_normal,
    }
    awful.placement.top_right(panel, { margins = { top = dpi(50), right =  panel_width + dpi(50)} } )

    local icon = clickable_container(wibox.widget {
        {
            {
                text = '󰂜',
                font = beautiful.icon_font .. 'Bold 15',
                align = 'center',
                valign = 'center',
                widget = wibox.widget.textbox,
            },
            fg = colors.blue,
            widget = wibox.container.background
        },
        margin = dpi(5),
        widget = wibox.container.margin
    })
    icon.toggle = function () panel.visible = not panel.visible end
    icon:connect_signal('button::press', function() icon.toggle() end)

    return icon
end
return init
