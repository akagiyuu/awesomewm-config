local bling = require('modules.bling')
local beautiful = require("beautiful")
local awful = require('awful')
local dpi = beautiful.xresources.apply_dpi

return bling.module.scratchpad {
    command                 = "kitty --class spad", -- How to spawn the scratchpad
    rule                    = { instance = "spad" }, -- The rule that the scratchpad will be searched by
    sticky                  = true, -- Whether the scratchpad should be sticky
    autoclose               = false, -- Whether it should hide itself when losing focus
    floating                = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry                = {
        x = beautiful.useless_gap,
        y = dpi(50),
        height = awful.screen.focused().geometry.height / 3,
        width = awful.screen.focused().geometry.width - beautiful.useless_gap * 2
    },
    reapply                 = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close = true, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
}
