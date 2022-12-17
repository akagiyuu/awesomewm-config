local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful     = require('beautiful')
local modalbind     = require("modules.modalbind")
-- local rubato        = require("modules.rubato")
local shift         = "Shift"
local ctrl          = "Control"
local alt           = "Mod2"

local modes = {
    volume = {
        { "d", function()
            awesome.emit_signal("signal::volume")
            awful.util.spawn("pamixer -d 6", false)
        end, "decrease volume" },

        { "u", function()
            awesome.emit_signal("signal::volume")
            awful.util.spawn("pamixer -i 6", false)
        end, "increase volume" },
        { "XF87AudioMute", function() awful.util.spawn("pamixer -t", false) end, "toggle mute" },
    }
}

awful.keyboard.append_global_keybindings {
    awful.key({ mod }, "s", hotkeys_popup.show_help, {
        description = "show help", group = "awesome"
    }),
    awful.key({ mod }, "w", function() awful.spawn("jgmenu") end, {
        description = "show main menu", group = "awesome"
    }),
    awful.key({ mod, ctrl }, "r", awesome.restart, {
        description = "reload awesome", group = "awesome"
    }),
    awful.key({ mod, shift }, "q", awesome.quit, {
        description = "quit awesome", group = "awesome"
    }),

    awful.key({ mod }, "Escape", function() awesome.emit_signal("module::powermenu:show") end, {
        description = "show exit menu", group = "awesome"
    }),
    awful.key({ mod }, "Return", function() awful.spawn(Terminal) end, {
        description = "open a terminal", group = "launcher"
    }),
    awful.key({ mod }, "p", function() awful.spawn(Paths.home .. "/.config/rofi/launchers/misc/launcher.sh") end, {
        description = "Apps", group = "launcher"
    }),
    awful.key({ mod }, "b", function() awful.spawn("firefox") end, {
        description = "Browser", group = "launcher"
    }),
    awful.key({ mod }, ".", function() awful.spawn("rofimoji") end, {
        description = "Emoji picker", group = "launcher"
    }),
    awful.key({ mod }, "`", function() require('ui.scratchpad').terminal:toggle() end, {
        description = 'Quake terminal', group = 'launcher'
    }),
    awful.key({ mod, ctrl }, "t", function()
        local wibar = awful.screen.focused().wibar
        wibar.visible = not wibar.visible
    end, { description = 'Toggle wibar' }),
}

awful.keyboard.append_global_keybindings {
    awful.key({ mod }, "Left", awful.tag.viewprev, {
        description = "view previous", group = "tag"
    }),

    awful.key({ mod }, "Right", awful.tag.viewnext, {
        description = "view next", group = "tag"
    }),
}

awful.keyboard.append_global_keybindings {
    awful.key({ mod, ctrl }, "j", function() awful.screen.focus_relative(1) end, {
        description = "focus the next screen", group = "screen"
    }),
    awful.key({ mod, ctrl }, "k", function() awful.screen.focus_relative(-1) end, {
        description = "focus the previous screen", group = "screen"
    }),
}

awful.keyboard.append_global_keybindings {
    awful.key({ mod }, "Tab", function() awesome.emit_signal("bling::window_switcher::turn_on") end, {
        description = "Window Switcher", group = "launcher"
    }),
    awful.key({ mod, ctrl }, "l", function() awful.tag.incmwfact(0.05) end, {
        description = "increase master width factor", group = "layout"
    }),

    awful.key({ mod, ctrl }, "h", function() awful.tag.incmwfact(-0.05) end, {
        description = "decrease master width factor", group = "layout"
    }),

    awful.key({ mod }, "j", function() awful.client.swap.bydirection("down") end, {
        description = "swap with next client by index"
    }),
    awful.key({ mod }, "k", function() awful.client.swap.bydirection("up") end, {
        description = "swap with previous client by index"
    }),
    awful.key({ mod }, "h", function() awful.client.swap.bydirection("left") end, {
        description = "swap with previous client by index"
    }),
    awful.key({ mod }, "l", function() awful.client.swap.bydirection("right") end, {
        description = "swap with previous client by index"
    }),
    awful.key({ mod, }, "space", function() awful.layout.inc(1) end, {
        description = "select next", group = "layout"
    }),
    awful.key({ mod, shift }, "space", function() awful.layout.inc(-1) end, {
        description = "select previous", group = "layout"
    }),
}

awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers   = { mod },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only() end
        end,
    },
    awful.key {
        modifiers   = { mod, ctrl },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then awful.tag.viewtoggle(tag) end
        end,
    },
    awful.key {
        modifiers   = { mod, shift },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if not client.focus then return end
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:move_to_tag(tag) end
        end,
    },
    awful.key {
        modifiers   = { mod, ctrl, shift },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if not client.focus then return end
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:toggle_tag(tag) end
        end,
    },
    awful.key {
        modifiers   = { mod },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function(index)
            local tag = awful.screen.focused().selected_tag
            if tag then tag.layout = tag.layouts[index] or tag.layout end
        end,
    }
}

awful.keyboard.append_global_keybindings {
    awful.key({}, "Print", function() awful.util.spawn("fish -c 'maim | xclip -selection clipboard -t image/png'") end, {
        description = "Fullscreen", group = "Screenshot"
    }),
    awful.key({ mod }, "Print", function() awful.util.spawn(Paths.home .. "/.local/bin/rofi_screenshot") end, {
        description = "Menu", group = "Screenshot"
    }),
    awful.key({ mod }, "v", function()
        modalbind.grab {
            keymap = modes.volume,
            name = "Volume",
            stay_in_mode = true
        }
    end)
}


client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings {
        awful.key({ mod, "Shift" }, "c", function(c) c:kill() end, {
            description = "close", group = "client"
        }),
        awful.key({ mod, }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "toggle fullscreen", group = "client" }),
        awful.key({ mod, ctrl }, "space", awful.client.floating.toggle, {
            description = "toggle floating", group = "client"
        }),
        awful.key({ mod }, "o", function(c) c:move_to_screen() end, {
            description = "move to screen", group = "client"
        }),
        awful.key({ mod }, "t", function(c) c.ontop = not c.ontop end, {
            description = "toggle keep on top", group = "client"
        }),

        awful.key({ mod, }, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "client" }),
        awful.key({ mod, ctrl }, "m", function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end, { description = "(un)maximize vertically", group = "client" }),
        awful.key({ mod, shift }, "m", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end, { description = "(un)maximize horizontally", group = "client" }),

        awful.key({ mod, }, "n", function(c) c.minimized = true end, {
            description = "minimize", group = "client"
        }),
        awful.key({ mod, ctrl }, "n", function()
            local c = awful.client.restore()
            if c then c:activate { raise = true, context = "key.unminimize" } end
        end, { description = "restore minimized", group = "client" })

    }
end)
