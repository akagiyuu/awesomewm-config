local wibox = require('wibox')
local beautiful = require('beautiful')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi
local misc = require('helper.misc')

return wibox.widget {
    require('widget.base.text') {
        text = '󰍛 ',
        italic = false,
        font = beautiful.icon_font,
        color = colors.brightgreen,
    },
    require('widget.base.text') {
        font = beautiful.font_name,
        color = colors.brightgreen,
        create_callback = function(self)
            watch('bash -c "free | grep -z Mem.*Swap.*"', 2, function(_, stdout)
                local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
                stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

                self.text = misc.round((used / 1048576), 0.01) .. ' GB'
                collectgarbage('collect')
            end)
        end,
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}
