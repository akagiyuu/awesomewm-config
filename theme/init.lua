local beautiful   = require('beautiful')
local colorscheme = require('theme.colorschemes')

local M = {}

---Init theme settings.
---@param options table
M.init = function(options)
    options = options or {}

    colorscheme.init(options.accent)

    local theme = require('theme.default')

    colorscheme.set_focus_colors(theme, colors[options.focus_color])

    for key, value in pairs(options) do
        theme[key] = value
    end

    beautiful.init(theme)
end

return M
