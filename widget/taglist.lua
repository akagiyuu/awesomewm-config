local awful           = require("awful")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
local dpi             = beautiful.xresources.apply_dpi
local helper          = require("helper")
local rubato          = require("module.rubato")
-- awful.util.tagnames =  { "1", "2" , "3", "4", "5", "6", "7", "8", "9" }
-- awful.util.tagnames =  { "", " ", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "dev",  "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx" }
-- awful.util.tagnames =  { "", "", " ", "","", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
awful.util.tagnames   = { "󰈹", "󰆍", "", "󰏗", "󰄄", "󰢻" }
-- awful.util.tagnames = { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", ""}

-- Pacman Taglist :
-- awful.util.tagnames = {"●", "●", "●", "●", "●", "●", "●", "●", "●", "●"}
-- awful.util.tagnames = {"", "", "", "", "", "", "", "", "", ""}
-- awful.util.tagnames = {"•", "•", "•", "•", "•", "•", "•", "•", "•", "•"}
-- awful.util.tagnames = { "", "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "",  "" }

local update_tags     = function(self, c3)
    if c3.selected then
        self:get_children_by_id("indicator_id")[1].bg = colors.brightred
        self.anim.target = 32
    elseif #c3:clients() == 0 then
        self:get_children_by_id("indicator_id")[1].bg = colors.brightblack
        self.anim.target = 8
    else
        self:get_children_by_id("indicator_id")[1].bg = colors.blue
        self.anim.target = 16
    end
end

local taglist_options = {
    filter = awful.widget.taglist.filter.all,
    buttons = {
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    },
    layout = { spacing = dpi(10), layout = wibox.layout.fixed.horizontal },
    widget_template = {
        {
            {
                valign = "center",
                {
                    id = 'indicator_id',
                    forced_height = dpi(10),
                    shape = helper.ui.rounded_rectangle(beautiful.border_radius),
                    widget = wibox.container.background
                },
                id = "place_id",
                widget = wibox.container.place
            },
            right = dpi(3),
            left = dpi(3),
            widget = wibox.container.margin
        },
        create_callback = function(self, c3, _, _)
            self.anim = rubato.timed {
                intro = 0.1,
                duration = 0.2,
                easing = rubato.quadratic,
                subscribed = function(width)
                    self:get_children_by_id("indicator_id")[1].forced_width =
                        dpi(width)
                end
            }

            update_tags(self, c3)
        end,
        update_callback = function(self, c3, _, _)
            update_tags(self, c3)
        end,
        layout = wibox.layout.align.vertical,
    }
}

return function(screen)
    awful.tag(awful.util.tagnames, screen, awful.layout.layouts[1])
    taglist_options.screen = screen
    return {
        awful.widget.taglist(taglist_options),
        top = dpi(14),
        bottom = dpi(14),
        right = dpi(5),
        left = dpi(5),
        widget = wibox.container.margin
    }
end
