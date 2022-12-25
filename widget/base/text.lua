-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------

local gtable = require("gears.table")
local gstring = require("gears.string")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helper = require("helper")

---@class TextWidgetOption
---@field width number
---@field height number
---@field halign number
---@field valign number
---@field id string
---@field font string
---@field bold boolean
---@field italic boolean
---@field size number
---@field color string
---@field text string
---@field create_callback function

---@class TextWidget
---@field _private TextWidgetOption
---@field font string
---@field markup string
---@field forced_width number
---@field forced_height number
---@field halign string
---@field valign string
---@field id string

local _text = { mt = {} }

---Generate widget markup
---@param widget TextWidget
local function generate_markup(widget)
    local bold_start = ""
    local bold_end = ""
    local italic_start = ""
    local italic_end = ""

    if widget._private.bold == true then
        bold_start = "<b>"
        bold_end = "</b>"
    end
    if widget._private.italic == true then
        italic_start = "<i>"
        italic_end = "</i>"
    end

    -- Need to unescape in a case the text was escaped by other code before
    widget._private.text = gstring.xml_unescape(tostring(widget._private.text))
    widget._private.text = gstring.xml_escape(tostring(widget._private.text))

    widget.markup = bold_start
        .. italic_start
        .. helper.ui.colorize_text(widget._private.text, widget._private.color)
        .. italic_end
        .. bold_end
end

function _text:set_width(width)
    self.forced_width = width
end

function _text:set_height(height)
    self.forced_height = height
end

function _text:set_horizontal_align(halign)
    self.halign = halign
end

function _text:set_font(font)
    self._private.font = font
    self._private.layout:set_font_description(beautiful.get_font(font))
    self:emit_signal("widget::redraw_needed")
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::font", font)
end

function _text:set_bold(bold)
    self._private.bold = bold
    generate_markup(self)
end

function _text:set_italic(italic)
    self._private.italic = italic
    generate_markup(self)
end

function _text:set_size(size)
    -- Remove the previous size from the font field
    local font = string.gsub(self._private.font, self._private.size, "")
    self._private.size = size
    self:set_font(font .. size)
end

function _text:set_color(color)
    self._private.color = color
    generate_markup(self)
end

function _text:set_text(text)
    self._private.text = text
    generate_markup(self)
end

---Generate text widget
---@param args TextWidgetOption
local function new(args)
    local opt = gtable.join({
        font = beautiful.font_name,
        size = 10,
        italic = true,
        bold = false,
        color = colors.white,
        text = '',
    }, args)

    local widget = wibox.widget({
        widget = wibox.widget.textbox,
        forced_width = opt.width,
        forced_height = opt.height,
        halign = opt.halign,
        valign = opt.valign,
        font = opt.font .. ' ' .. opt.size,
        id = opt.id
    })

    gtable.crush(widget, _text, true)

    widget._private.font = opt.font
    widget._private.bold = opt.bold
    widget._private.italic = opt.italic
    widget._private.size = opt.size
    widget._private.color = opt.color
    widget._private.text = opt.text

    generate_markup(widget)

    if opt.create_callback ~= nil then
        opt.create_callback(widget)
    end

    return widget
end

function _text.mt:__call(...)
    return new(...)
end

return setmetatable(_text, _text.mt)
