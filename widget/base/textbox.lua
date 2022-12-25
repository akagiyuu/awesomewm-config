local wibox = require('wibox')
local beautiful = require('beautiful')

local default_font_size = 14

---@class TextboxOption
---@field text string
---@field type? "'text'" | "'icon'"
---@field style? "'Bold'" | "'Italic'"
---@field size? number

---Generate textbox
---@param options TextboxOption
---@return unknown
return function(options)
    return wibox.widget {
        text = options.text,
        font = table.concat({
            options.type == 'text' and beautiful.font_name or beautiful.icon_font,
            options.style or '',
            tostring(options.size or default_font_size)
        }, ' '),
        widget = wibox.widget.textbox,
    }
end
