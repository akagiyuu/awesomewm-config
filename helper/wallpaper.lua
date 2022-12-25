local awful = require('awful')

local _wallpaper = {}

--- Apply wallpaper with effect
---@param effect?
---|"'blur'"
---|"'dim'"
---|"'pixel'"
_wallpaper.apply = function(effect)
    awful.spawn('betterlockscreen -w ' .. (effect and effect or ''))
end

function _wallpaper:blur_wallpaper_if_exist_window()
    if #awful.client.visible(awful.screen.focused()) > 0 then
        self.apply('blur')
        return
    end
    -- check if any open clients

    self.apply()
end

function _wallpaper:event_register()
    client.connect_signal('manage', function()
        self:blur_wallpaper_if_exist_window()
    end)
    client.connect_signal('unmanage', function()
        self:blur_wallpaper_if_exist_window()
    end)
    client.connect_signal('request:activate', function()
        self:blur_wallpaper_if_exist_window()
    end)
    tag.connect_signal('property::selected', function()
        self:blur_wallpaper_if_exist_window()
    end)
end

return _wallpaper
