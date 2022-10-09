-- ## Keyboard layout ##
-- ~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local wibox = require('wibox')
local awful = require("awful")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

-- Keyboard :
local keyboardlayout = awful.widget.keyboardlayout()
keyboardlayout.widget.font = beautiful.font
local keyboard_icon = wibox.widget {
	markup = '<span font="' .. beautiful.icon_font .. '"></span>',
	widget = wibox.widget.textbox,
}

return wibox.widget {
	wibox.widget{
		keyboard_icon,
		fg = colors.brightblue,
		widget = wibox.container.background
	},
    wibox.widget{
        keyboardlayout,
        fg = colors.brightblue,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}
