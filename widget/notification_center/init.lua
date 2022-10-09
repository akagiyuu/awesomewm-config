local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local notif_header = wibox.widget {
	text   = 'Notification Center',
	font   = 'Cascadia Code Italic 14',
	align  = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local notif_center = function(screen)

	screen.clear_all = require('widget.notification_center.clear-all')
	screen.notifbox_layout = require('widget.notification_center.build-notifbox').notifbox_layout

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

return notif_center