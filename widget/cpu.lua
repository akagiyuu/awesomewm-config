local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')


local cpu_widget = wibox.widget {
    require('widget.base.text') {
        text = ' ',
        font = beautiful.icon_font,
        italic = false,
        color = colors.brightblue,
    },
    require('widget.base.text') {
        font = beautiful.font_name,
        color = colors.brightblue,
        create_callback = function(self)
            local total_prev = 0
            local idle_prev = 0

            watch([[bash -c "cat /proc/stat | grep '^cpu '"]], 2, function(_, stdout)
                local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
                stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

                local total = user + nice + system + idle + iowait + irq + softirq + steal

                local diff_idle = idle - idle_prev
                local diff_total = total - total_prev
                local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

                self.text = math.floor(diff_usage) .. '%'
                if diff_usage < 10 then
                    self.text = '0' .. self.text
                end

                total_prev = total
                idle_prev = idle
                collectgarbage('collect')
            end)

        end
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

return cpu_widget
