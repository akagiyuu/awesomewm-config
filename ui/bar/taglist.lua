local awful = require("awful")
local wibox = require("wibox")

-- awful.util.tagnames =  { "1", "2" , "3", "4", "5", "6", "7", "8", "9" }
-- awful.util.tagnames =  { "", " ", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "dev",  "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx" }
-- awful.util.tagnames =  { "", "", " ", "","", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
awful.util.tagnames = { "󰆍", "󰈹", "", "", "󰇮", "󰏗", "󰄄", "󰢻" }
-- awful.util.tagnames = { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", ""}

-- Pacman Taglist :
-- awful.util.tagnames = {"●", "●", "●", "●", "●", "●", "●", "●", "●", "●"}
-- awful.util.tagnames = {"", "", "", "", "", "", "", "", "", ""}
-- awful.util.tagnames = {"•", "•", "•", "•", "•", "•", "•", "•", "•", "•"}
-- awful.util.tagnames = { "", "", "", "", "", "", "", "", "", "" }
-- awful.util.tagnames =  { "", "", "", "", "", "", "", "", "",  "" }

local taglist_options = {
    filter = awful.widget.taglist.filter.all,
    buttons = {
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    },
    widget_template = {
        nil,
        {
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
            },
            right  = 5,
            left   = 5,
            widget = wibox.container.margin,
        },
        create_callback = function(self, c3, _, _)
            self:connect_signal('mouse::enter', function()
                if #c3:clients() <= 0 then return end

                awesome.emit_signal("bling::tag_preview::update", c3)
                awesome.emit_signal("bling::tag_preview::visibility", screen, true)
            end)
            self:connect_signal('mouse::leave', function()
                awesome.emit_signal("bling::tag_preview::visibility", screen, false)
            end)
        end,

        layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.fixed.horizontal,
}

return function(screen)
    awful.tag(awful.util.tagnames, screen, awful.layout.layouts[1])
    taglist_options.screen = screen
    return awful.widget.taglist(taglist_options)
end
