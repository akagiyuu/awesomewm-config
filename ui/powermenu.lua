local awful     = require("awful")
local dpi       = require("beautiful").xresources.apply_dpi
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helper    = require('helper')
local button    = require('container.button')
local system    = require('helper.system')
local capi      = { awesome = awesome, mouse = mouse }

local icondir = Paths.icon .. "powermenu/"

local update_user_name = function(profile)
    awful.spawn.easy_async_with_shell('printf "$(whoami)@$(uname -n)"',
        function(stdout) profile.name:set_text(stdout) end)
end

local profile = {
    picture = wibox.widget {
        image = Paths.config_directory .. "assets/profile.jpg",
        resize = true,
        forced_height = dpi(200),
        clip_shape = helper.ui.rounded_rectangle(30),
        widget = wibox.widget.imagebox
    },
    name = require('widget.base.text') {
        text = " ",
        font = beautiful.font_name,
        size = 30,
        halign = 'center',
        valign = 'center',
    }
}

local shutdown_button = button("Shutdown", icondir .. "shutdown.svg", colors.blue, system.shutdown)
local reboot_button = button("Reboot", icondir .. "reboot.svg", colors.red, system.reboot)
local suspend_button = button("Suspend", icondir .. "suspend.svg", colors.yellow, system.suspend)
local lock_button = button("Lock", icondir .. "lock.svg", colors.cyan, system.lock)
local logout_button = button("Logout", icondir .. "logout.svg", colors.green, system.logout)

local create_powermenu_screen = function(screen)
    update_user_name(profile)

    local powermenu = wibox.widget {
        nil,
        {
            {
                nil,
                {
                    {
                        profile.picture,
                        valign = "center",
                        halign = "center",
                        widget = wibox.container.place
                    },
                    spacing = dpi(50),
                    {
                        profile.name,
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.vertical
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            {
                nil,
                {
                    shutdown_button,
                    reboot_button,
                    logout_button,
                    lock_button,
                    suspend_button,
                    spacing = dpi(30),
                    layout = wibox.layout.fixed.horizontal
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        nil,
        layout = wibox.layout.align.vertical,
        expand = "none",
    }
    local powermenu_container = wibox {
        widget = powermenu,
        screen = screen,
        type = "splash",
        visible = false,
        ontop = true,
        bg = "#21212188",
        height = screen.geometry.height,
        width = screen.geometry.width,
        x = screen.geometry.x,
        y = screen.geometry.y
    }


    local powermenu_keygrabber = awful.keygrabber {
        autostart = false,
        stop_event = 'release',
        keypressed_callback = function(_, _, key, _)
            if key == 'Escape' then capi.awesome.emit_signal("module::powermenu:hide") end
        end
    }

    capi.awesome.connect_signal("module::powermenu:show", function()
        if screen ~= capi.mouse.screen then return end

        powermenu_container.visible = true
        powermenu_keygrabber:start()
    end)

    capi.awesome.connect_signal("module::powermenu:hide", function()
        powermenu_container.visible = false
        powermenu_keygrabber:stop()
    end)
end

return create_powermenu_screen
