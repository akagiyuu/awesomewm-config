local awful      = require("awful")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local helper     = require('helper')

local bar_element_container = require('container.bar_element')
local clock_widget          = require('widget.clock')
-- local temprature_widget     = bar_element_container(require 'widget.temprature')
local mem_widget            = bar_element_container(require 'widget.memory')
local cpu_widget            = bar_element_container(require 'widget.cpu')
-- local updates_widget        = bar_element_container(require 'widget.updates')
-- local fs_widget             = bar_element_container(require 'widget.fs-widget' { mounts = { '/', '/home' } })
-- local network               = bar_element_container(require 'widget.net_speed' {})
local powerbutton           = require('widget.power')

awful.screen.connect_for_each_screen(function(screen)
    screen.promptbox = awful.widget.prompt()
    screen.notification_center = require("ui.notification.center")(screen)
    screen.layoutbox = wibox.widget {
        {
            screen = screen,
            visible = true,
            buttons = {
                awful.button({}, 1, function() awful.layout.inc(1) end),
                awful.button({ mod }, 1, function() awful.layout.inc(-1) end),
            },
            widget = awful.widget.layoutbox,
        },
        margins = dpi(7),
        widget = wibox.container.margin,
    }
    screen.taglist = require('widget.taglist')(screen)
    screen.tasklist = require('widget.tasklist')(screen)
    screen.systray = require('widget.systray')
    require("ui.powermenu")(screen)

    screen.wibar = awful.wibar {
        position = "top",
        type = "dock",
        ontop = false,
        stretch = false,
        visible = true,
        height = dpi(35),
        width = screen.geometry.width - dpi(20),
        screen = screen,
        bg = colors.transparent,
    }
    awful.placement.top(screen.wibar, { margins = beautiful.useless_gap * 2 })
    screen.wibar:struts { top = dpi(50) }

    screen.wibar:setup {
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            {
                {
                    powerbutton,
                    screen.taglist,
                    {
                        screen.tasklist,
                        right = 15,
                        widget = wibox.container.margin
                    },
                    spacing = dpi(10),
                    bg = colors.black,
                    layout = wibox.layout.fixed.horizontal,
                },
                bg = colors.black,
                shape = helper.ui.rounded_rectangle(),
                widget = wibox.container.background,
            },
            {
                {
                    {
                        clock_widget,
                        left = 20,
                        right = 20,
                        widget = wibox.container.margin
                    },
                    bg = colors.black,
                    layout = wibox.layout.align.horizontal,
                },
                bg = colors.black,
                shape = helper.ui.rounded_rectangle(),
                widget = wibox.container.background,
            },
            {
                {
                    -- {
                    --     updates_widget,
                    --     left = 15,
                    --     widget = wibox.container.margin
                    -- },
                    cpu_widget,
                    mem_widget,
                    -- network,
                    -- fs_widget,
                    -- temprature_widget,
                    screen.systray,
                    screen.layoutbox,
                    {
                        screen.notification_center,
                        right = 15,
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                bg = colors.black,
                shape = helper.ui.rounded_rectangle(),
                widget = wibox.container.background,
            }
        },
        -- left = beautiful.useless_gap,
        -- right = beautiful.useless_gap,
        widget = wibox.container.margin,
    }
end)
