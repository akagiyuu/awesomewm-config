local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helper    = require("helper")
local dpi       = beautiful.xresources.apply_dpi
-- local rubato = require('module.rubato')
-- local color = require('modules.color')
--
-- local normal = color.color({ hex = beautiful.border_normal })
-- local focus = color.color({ hex = beautiful.border_focus} )
-- local transition = color.transition(normal, focus, 0)

return function(screen)
    return awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({}, 1, function(c) c:activate { context = "tasklist", action = "toggle_minimization" } end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx( -1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        },
        style = {
            shape = helper.ui.rounded_rectangle(beautiful.border_radius / 3),
            border_width = 1,
            border_color = colors.black,
            -- shape = function(cr, w, h)
            --     gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
            -- end,
            fg_focus = colors.black,
            bg_focus = colors.cyan,
        },
        layout = { layout = wibox.layout.fixed.horizontal },
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id = "clienticon",
                                widget = awful.widget.clienticon
                            },
                            margins = dpi(2),
                            widget = wibox.container.margin
                        },
                        {
                            forced_width = dpi(8),
                            layout = wibox.layout.fixed.horizontal
                        },
                        {
                            id = 'text_role',
                            -- forced_width = dpi(150),
                            widget = wibox.widget.textbox,
                        },
                        {
                            forced_width = dpi(2),
                            layout = wibox.layout.fixed.horizontal
                        },
                        widget = wibox.layout.fixed.horizontal
                    },
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                id = 'background_role',
                widget = wibox.container.background
            },
            layout = wibox.layout.align.horizontal
        }
    }
end
