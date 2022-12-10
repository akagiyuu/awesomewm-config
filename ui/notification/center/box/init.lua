local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local empty_notifbox = require(... .. '.empty')
local notifbox_scroller = require(... .. '.scroller')

local notif_core = {}

notif_core.remove_notifbox_empty = true

notif_core.notifbox_layout = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    empty_notifbox
}

notifbox_scroller(notif_core.notifbox_layout)

notif_core.reset_notifbox_layout = function()
    notif_core.notifbox_layout:reset()
    notif_core.notifbox_layout:insert(1, empty_notifbox)
    notif_core.remove_notifbox_empty = true
end

local notifbox_add = function(n, notif_icon, notifbox_color)
    if #notif_core.notifbox_layout.children == 1 and notif_core.remove_notifbox_empty then
        notif_core.notifbox_layout:reset(notif_core.notifbox_layout)
        notif_core.remove_notifbox_empty = false
    end

    local notifbox_box = require('ui.notification.center.box.builder')
    notif_core.notifbox_layout:insert(
        1,
        notifbox_box(
            n,
            notif_icon,
            n.title,
            n.message,
            n.app_name,
            notifbox_color
        )
    )
end

local notifbox_add_expired = function(n, notif_icon, notifbox_color)
    n:connect_signal('destroyed', function(_, reason, _)
        if reason == 1 then notifbox_add(n, notif_icon, notifbox_color) end
    end)
end

naughty.connect_signal('request::display', function(notification)
    -- local notifbox_color = notification.urgency and notification.bg .. '66' or beautiful.transparent

    local notif_icon = notification.icon or notification.app_icon or Paths.icon .. 'notification/new-notif.svg'

    notifbox_add_expired(notification, notif_icon, beautiful.transparent)
end
)

return notif_core
