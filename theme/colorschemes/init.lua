local M = {}

M.init = function(theme)
    theme = theme or "ayu"
    local color_palette = require(string.format("theme.colorschemes.%s", theme))

    _G.colors             = {
        black         = color_palette[1],
        red           = color_palette[2],
        green         = color_palette[3],
        yellow        = color_palette[4],
        blue          = color_palette[5],
        magenta       = color_palette[6],
        cyan          = color_palette[7],
        white         = color_palette[8],
        brightblack   = color_palette[9],
        brightred     = color_palette[10],
        brightgreen   = color_palette[11],
        brightyellow  = color_palette[12],
        brightblue    = color_palette[13],
        brightmagenta = color_palette[14],
        brightcyan    = color_palette[15],
        brightwhite   = color_palette[16],
        container     = color_palette[17],
    }
    _G.colors.transparent = "#00000000"

    _G.colors.random = function()
        return color_palette[math.random(1, #color_palette)]
    end
end

---Generate focus related color
---@param theme table
---@param color string color code in hex
M.set_focus_colors = function(theme, color)
    if color == nil or color:match("^#?%x%x%x%x%x%x$") == nil then
        color = "#59C2FF"
    end

    theme.taglist_fg_focus          = color
    theme.fg_focus                  = color
    theme.border_focus              = color
    theme.border_marked             = color
    theme.notification_border_color = color
    theme.menu_border_color         = color
    theme.titlebar_fg_focus         = color
    theme.modebox_border      = color
end

return M
