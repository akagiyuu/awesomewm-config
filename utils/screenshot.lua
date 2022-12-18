local awful     = require('awful')
local naughty   = require('naughty')
local gears     = require('gears')
local beautiful = require('beautiful')

awful.screenshot.directory = Paths.home .. "/Pictures/Screenshots/"
awful.screenshot.prefix = ''

awful.screenshot.frame_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
end

local screenshot = {}

local count_down = function(delay)
    local notification = naughty.notification {
        title   = "Screenshot in:",
        message = tostring(delay) .. " seconds"
    }

    screenshot.manager:connect_signal("timer::tick", function(_, remain)
        notification.message = tostring(remain) .. " seconds"
    end)

    screenshot.manager:connect_signal("timer::timeout", function()
        if notification then notification:destroy() end
    end)
end

local file_to_clipboard = function(file_path)
    awful.spawn('xclip -selection clipboard -t image/png -i ' .. file_path)
    awful.spawn('rm ' .. file_path)
end

function screenshot:__save(clipboard)
    local file_path = self.manager.file_path

    if clipboard then
        file_to_clipboard(file_path)
        naughty.notification { title = "Saved to clipboard" }
    else
        naughty.notification { title = "Saved to " .. file_path }
    end
end

function screenshot:save(args)
    self.manager = awful.screenshot(args)
    local file_path = self.manager.file_path

    if args.auto_save_delay > 0 then
        screenshot.manager:connect_signal("file::saved", self:__save(args.clipboard))
    else
        self:__save(args.clipboard)
    end
end

function screenshot:take(args)
    screenshot:save(args)

    if args.auto_save_delay > 0 then
        count_down(args.auto_save_delay)
    end
end

return setmetatable(screenshot, {
    __call = function(self, ...) self:take(...) end
})
