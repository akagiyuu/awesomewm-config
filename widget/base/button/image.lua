local gtable = require('gears.table')
local dpi = require("beautiful").xresources.apply_dpi
local wibox = require("wibox")
local clickable_container = require('container.clickable')
local helper = require('helper')

---@class ImageButtonOption
---@field text_opts TextWidgetOption
---@field icon_path string
---@field background string
---@field border_radius number
---@field on_press function

---Generate image button widget
---@param args ImageButtonOption
---@return unknown
local new = function(args)
    ---@type ImageButtonOption
    local opts = gtable.join({
        text = '',
        background = colors.black,
        on_press = function() end,
    }, args)

    local item = wibox.widget {
        {
            {
                {
                    {
                        {
                            image = opts.icon_path,
                            resize = true,
                            forced_height = dpi(30),
                            widget = wibox.widget.imagebox
                        },
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    {
                        require('widget.base.text')(args.text_opts),
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    widget = wibox.layout.fixed.horizontal
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            fg = opts.foreground,
            bg = opts.background,
            shape = helper.ui.rounded_rectangle(opts.border_radius),
            widget = wibox.container.background,
            id = 'background'
        },
        spacing = dpi(0),
        layout = wibox.layout.align.vertical
    }

    item = clickable_container(item)
    item:connect_signal("button::release", function() args.on_press() end)

    return item
end
return new
