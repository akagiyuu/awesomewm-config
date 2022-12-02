local naughty = require("naughty")
local rnotification = require("ruled.notification")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local awful = require("awful")
local clickable_container = require("widget.clickable_container")
local app_icons = {
    ["firefox"] = '󰈹',
    ["kitty"] = '',
    ["screenshot tool"] = "󰄄" ,
    ["color picker"] = "󰴱",
}

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "An error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)

rnotification.connect_signal("request::rules", function()
    rnotification.append_rule {
        rule       = { urgency = "critical" },
        properties = { fg = colors.red }
    }
end)

naughty.connect_signal('request::display', function(n)
    local actions_template = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(0),
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'text_role',
                            font   = beautiful.font_name .. ' Regular 10',
                            widget = wibox.widget.textbox
                        },
                        widget = wibox.container.place
                    },
                    widget = clickable_container
                },
                bg            = beautiful.groups_bg,
                shape         = gears.shape.rounded_rect,
                forced_height = dpi(30),
                widget        = wibox.container.background
            },
            margins = dpi(4),
            widget  = wibox.container.margin
        },
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions
    }
    local random_color = colors.random()
    local app_name = wibox.widget {
        {
            markup = n.app_name and n.app_name:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end) or
                'System Notification',
            font = beautiful.font_name .. ' Bold 16',
            align = 'center',
            valign = 'center',
            widget = wibox.widget.textbox

        },
        top    = dpi(15),
        widget = wibox.container.margin,
    }

    local icon = app_icons[n.app_name:lower()] or ""
    icon = wibox.widget {
        {
            {
                {
                    {
                        image = n.icon,
                        resize = true,
                        clip_shape = gears.shape.circle,
                        halign = "center",
                        valign = "center",
                        widget = wibox.widget.imagebox,
                    },
                    border_width = dpi(2),
                    border_color = random_color,
                    shape = gears.shape.circle,
                    widget = wibox.container.background,
                },
                strategy = "exact",
                height = dpi(40),
                width = dpi(40),
                widget = wibox.container.constraint,
            },
            {
                nil,
                nil,
                {
                    nil,
                    nil,
                    {
                        {
                            font = beautiful.icon_font .. " 10",
                            markup = "<span foreground='" ..
                                beautiful.notification_bg .. "'>" .. icon .. "</span>",
                            align = "center",
                            valign = "center",
                            widget = wibox.widget.textbox,
                        },
                        bg = random_color,
                        widget = wibox.container.background,
                        shape = gears.shape.circle,
                        forced_height = dpi(20),
                        forced_width = dpi(20),
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                },
                layout = wibox.layout.align.vertical,
                expand = "none",
            },
            layout = wibox.layout.stack,
        },
        margins = beautiful.notification_margin,
        widget  = wibox.container.margin,
    }

    local message = wibox.widget {
        {
            layout = wibox.layout.align.vertical,
            expand = 'none',
            nil,
            {
                {
                    align = 'left',
                    widget = naughty.widget.title
                },
                {
                    align = 'left',
                    widget = naughty.widget.message,
                },
                layout = wibox.layout.fixed.vertical
            },
            nil
        },
        margins = beautiful.notification_margin,
        widget  = wibox.container.margin,
    }

    naughty.layout.box {
        notification = n,
        type = 'notification',
        screen = awful.screen.preferred(),
        widget_template = {
            {
                {
                    {
                        app_name,
                        {
                            icon,
                            message,
                            layout = wibox.layout.fixed.horizontal,
                        },
                        fill_space = true,
                        spacing    = beautiful.notification_margin,
                        layout     = wibox.layout.fixed.vertical,
                    },

                    -- Actions
                    actions_template,
                    spacing = dpi(4),
                    layout  = wibox.layout.fixed.vertical,
                },
                strategy = 'max',
                width    = dpi(500),
                widget   = wibox.container.constraint
            },
            id = 'background_role',
            widget = wibox.container.background
        }
    }
end)
