local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi


return wibox.widget {
    require('widget.base.text') {
        text   = ' ',
        font   = beautiful.icon_font,
        size   = 14,
        italic = false,
        halign = "center",
        valign = "center",
        color  = colors.yellow,
    },
    require('widget.base.text') {
        font = beautiful.font,
        color = colors.yellow,
        create_callback = function(self)
            watch('bash -c "checkupdates | wc -l"', 3600, function(_, stdout)
                self.text = stdout
                collectgarbage('collect')
            end)
        end,
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}
