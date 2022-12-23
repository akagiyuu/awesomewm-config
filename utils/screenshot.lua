local awful     = require('awful')
local naughty   = require('naughty')
local gears     = require('gears')
local beautiful = require('beautiful')

awful.screenshot.directory = Paths.home .. "/Pictures/Screenshots/"
awful.screenshot.prefix = ''

awful.screenshot.frame_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
end

local count_down = function(screenshot, delay)
    local notification = naughty.notification {
        title   = "Screenshot in:",
        message = tostring(delay) .. " seconds"
    }

    screenshot:connect_signal("timer::tick", function(_, remain)
        notification.message = tostring(remain) .. " seconds"
    end)

    screenshot:connect_signal("timer::timeout", function()
        if notification then notification:destroy() end
    end)
end

local take = function(args)
    local screenshot = awful.screenshot(args)
    local delay = args.auto_save_delay
    local path = screenshot.file_path

    if delay == 0 then
        awful.spawn('xclip -selection clipboard -t image/png -i ' .. path)
        naughty.notification { title = "Screenshot saved" }
        return
    end

    count_down(screenshot, delay)
    screenshot:connect_signal("file::saved", function()
        awful.spawn('xclip -selection clipboard -t image/png -i ' .. path)
        naughty.notification { title = "Screenshot saved" }
    end)
end

return take
