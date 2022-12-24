local bling = require(... .. '.bling')
local modalbind = require(... .. '.modalbind')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

modalbind.init()
modalbind.set_opacity(0.5)
modalbind.set_location('top')

bling.widget.window_switcher.enable {
    type = 'thumbnail',

    hide_window_switcher_key = 'Escape', -- The key on which to close the popup
    minimize_key = 'n', -- The key on which to minimize the selected client
    unminimize_key = 'N', -- The key on which to unminimize all clients
    kill_client_key = 'q', -- The key on which to close the selected client
    cycle_key = 'Tab', -- The key on which to cycle through all clients
    previous_key = 'Left', -- The key on which to select the previous client
    next_key = 'Right', -- The key on which to select the next client
    vim_previous_key = 'h', -- Alternative key on which to select the previous client
    vim_next_key = 'l', -- Alternative key on which to select the next client

    cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
    filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
}
bling.widget.tag_preview.enable {
    show_client_content = false, -- Whether or not to show the client content
    x = 10, -- The x-coord of the popup
    y = 10, -- The y-coord of the popup
    scale = 0.25, -- The scale of the previews compared to the screen
    honor_padding = false, -- Honor padding when creating widget size
    honor_workarea = false, -- Honor work area when creating widget size
    placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.top_left(c, {
            margins = {
                top = 60,
                left = 10
            }
        })
    end,
    background_widget = wibox.widget { -- Set a background image (like a wallpaper) for the widget
        image                 = beautiful.wallpaper,
        horizontal_fit_policy = 'fit',
        vertical_fit_policy   = 'fit',
        widget                = wibox.widget.imagebox
    }
}
-- bling.widget.task_preview.enable {
--     x = 20,                    -- The x-coord of the popup
--     y = 20,                    -- The y-coord of the popup
--     height = 200,              -- The height of the popup
--     width = 200,               -- The width of the popup
--     placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
--         awful.placement.top_left(c, {
--             margins = {
--                 top = 60,
--                 left = 300,
--             }
--         })
--     end
-- }
