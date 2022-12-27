local awful     = require("awful")
local dpi       = require("beautiful").xresources.apply_dpi
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helper    = require('helper')
local system    = require('helper.system')
local misc      = require('helper.misc')
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

local button = function(name, background)
    return require('widget.base.button.image') {
        text_opts = {
            text = misc.capitalize(name),
            bold = true,
            italic = false,
            size = 30,
            color = '#212121'
        },
        icon_path = string.format('%s%s.svg', icondir, name),
        background = background,
        border_radius = 10,
        on_press = system[name],
    }
end


local create_powermenu_screen = function(screen)
    update_user_name(profile)

    local powermenu = wibox.widget {
        {
            {
                {
                    {
                        profile.picture,
                        valign = "center",
                        halign = "center",
                        widget = wibox.container.place
                    },
                    {
                        profile.name,
                        margins = dpi(0),
                        widget = wibox.container.margin
                    },
                    spacing = dpi(50),
                    layout = wibox.layout.fixed.vertical
                },
                halign = 'center',
                valign = 'center',
                widget = wibox.container.place
            },
            {
                {
                    button('shutdown', colors.blue),
                    button('reboot', colors.red),
                    button('suspend', colors.yellow),
                    button('lock', colors.cyan),
                    button('logout', colors.green),
                    spacing = dpi(30),
                    layout = wibox.layout.fixed.horizontal
                },
                halign = 'center',
                valign = 'center',
                widget = wibox.container.place
            },
            layout = wibox.layout.align.vertical
        },
        halign = 'center',
        valign = 'center',
        widget = wibox.container.place
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
