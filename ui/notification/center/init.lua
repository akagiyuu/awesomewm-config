local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('container.clickable')
local panel_width = dpi(350)

local notif_header = wibox.widget {
    text   = 'Notification Center',
    font   = beautiful.font .. ' Italic 14',
    align  = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
}

local notification_center = function(screen)

    screen.clear_all = require('ui.notification.center.clear-all')
    screen.notifbox_layout = require('ui.notification.center.box').notifbox_layout

    return wibox.widget {
        {
            {
                expand = 'none',
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10),
                {
                    layout = wibox.layout.align.horizontal,
                    expand = 'none',
                    notif_header,
                    nil,
                    screen.clear_all
                },
                screen.notifbox_layout
            },
            margins = dpi(10),
            widget = wibox.container.margin
        },
        bg = beautiful.groups_bg,
        widget = wibox.container.background
    }
end

local notification_icon = function(screen)
    local panel = awful.popup {
        widget  = {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    forced_width = dpi(panel_width),
                    forced_height = (screen.geometry.height - dpi(100)),
                    spacing = dpi(10),
                    notification_center(screen)
                },
                margins = dpi(20),
                widget = wibox.container.margin
            },

            id           = 'info_center',
            border_width = dpi(1),
            border_color = beautiful.border_focus,
            widget       = wibox.container.background
        },
        screen  = screen,
        visible = false,
        ontop   = true,
        bg      = colors.transparent,
        fg      = beautiful.fg_normal,
    }
    awful.placement.top_right(panel, { margins = { top = dpi(50), right = panel_width + dpi(50) } })

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
    icon.toggle = function() panel.visible = not panel.visible end
    icon:connect_signal('button::press', function() icon.toggle() end)

    return icon
end
return notification_icon
