local awful = require 'awful'
local ruled = require 'ruled'

ruled.client.connect_signal('request::rules', function()
    ruled.client.append_rule {
        id         = 'global',
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
        }
    }

    -- ruled.client.append_rule {
    --     id         = 'titlebars',
    --     rule_any   = { type = { 'normal', 'dialog' } },
    --     properties = { titlebars_enabled = true }
    -- }

    ruled.client.append_rule {
        id         = 'floating',
        rule_any   = {
            instance = { 'copyq', 'pinentry' },
            class    = {
                'ModernGL',
                'Virt-manager',
                'Pavucontrol',
                'Lxappearance',
                'qt5ct',
            },
            name     = { 'Event Tester' },
            role     = { 'pop-up' }
        },
        properties = { floating = true }
    }

    ruled.client.append_rule {
        id = 'center_placement',
        rule_any = {
            type = { 'dialog' },
            role = { 'GtkFileChooserDialog' }
        },
        properties = { placement = awful.placement.center }
    }

    ruled.client.append_rule {
        id = 'mpv',
        rule_any = {
            class = { 'mpv' }
        },
        properties = {
            fullscreen = true,
        }
    }
end)

ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
            position         = 'top_right',
        }
    }
end)

-- require('util.wallpaper'):event_register()

-- local function rounded_corners(client)
--     client.shape = function(cr, w, h)
--         gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
--     end
-- end
--
-- local function squared_corners(client)
--     client.shape = gears.shape.rectangle
-- end
--
-- local function client_corner_handle(client)
--     if client.class ~= 'mpv' and not client.fullscreen and not client.maximized then
--         rounded_corners(client)
--     else
--         squared_corners(client)
--     end
-- end
--
-- client.connect_signal('manage', function(c) client_corner_handle(c) end)
-- client.connect_signal('property::fullscreen', function(c) client_corner_handle(c) end)
-- client.connect_signal('property::maximized', function(c) client_corner_handle(c) end)
