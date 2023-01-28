local awful         = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local helper        = require('helper')
local modalbind     = require('module.modalbind')
local mode          = require('config.keymap.mode')
local capi          = {
    awesome = awesome
}

awful.keyboard.append_global_keybindings {
    awful.key({ mod }, 's', hotkeys_popup.show_help, {
        description = 'show help', group = 'awesome'
    }),
    awful.key({ mod }, 'w', function() awful.spawn('jgmenu') end, {
        description = 'show main menu', group = 'awesome'
    }),
    awful.key({ mod, ctrl }, 'r', capi.awesome.restart, {
        description = 'reload awesome', group = 'awesome'
    }),
    awful.key({ mod, shift }, 'q', capi.awesome.quit, {
        description = 'quit awesome', group = 'awesome'
    }),
    awful.key(
        { mod }, 'Escape',
        function() capi.awesome.emit_signal('module::powermenu:show') end,
        { description = 'show exit menu', group = 'awesome' }
    ),
    awful.key(
        { mod }, 'Return',
        function() awful.spawn(Terminal) end,
        { description = 'open a terminal', group = 'launcher' }
    ),
    awful.key(
        { mod }, 'p',
        function() awful.spawn(Paths.home .. '/.config/rofi/launchers/misc/launcher.sh') end,
        { description = 'Apps', group = 'launcher' }
    ),
    awful.key(
        { mod }, 'b',
        function() awful.spawn(Browser) end,
        { description = 'Browser', group = 'launcher' }
    ),
    awful.key(
        { mod }, '.',
        function() awful.spawn('rofimoji') end,
        { description = 'Emoji picker', group = 'launcher' }
    ),
    awful.key(
        { mod }, '`',
        function() require('ui.scratchpad').terminal:toggle() end,
        { description = 'Quake terminal', group = 'launcher' }
    ),
}

awful.keyboard.append_global_keybindings {
    awful.key(
        { mod }, '[',
        awful.tag.viewprev,
        { description = 'view previous', group = 'tag' }
    ),

    awful.key(
        { mod }, ']',
        awful.tag.viewnext,
        { description = 'view next', group = 'tag' }
    ),
    awful.key {
        modifiers   = { mod },
        keygroup    = 'numrow',
        description = 'switch to tag',
        group       = 'tag',
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only() end
        end,
    },
    awful.key {
        modifiers   = { mod, shift },
        keygroup    = 'numrow',
        description = 'move focused client to tag',
        group       = 'tag',
        on_press    = function(index)
            if not client.focus then return end
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:move_to_tag(tag) end
        end,
    },
}

awful.keyboard.append_global_keybindings {
    awful.key(
        { mod }, 'space',
        function() awful.layout.inc(1) end,
        { description = 'select next', group = 'layout' }
    ),
    awful.key(
        { mod, shift }, 'space',
        function() awful.layout.inc(-1) end,
        { description = 'select previous', group = 'layout' }
    ),
    awful.key {
        modifiers   = { mod },
        keygroup    = 'numpad',
        description = 'select layout directly',
        group       = 'layout',
        on_press    = function(index)
            local tag = awful.screen.focused().selected_tag
            if tag then tag.layout = tag.layouts[index] or tag.layout end
        end,
    }
}

awful.keyboard.append_global_keybindings {
    awful.key(
        { mod }, 'Tab',
        function() capi.awesome.emit_signal('bling::window_switcher::turn_on') end,
        { description = 'Window Switcher', group = 'client' }
    ),
    awful.key(
        { mod }, 'j',
        function() awful.client.swap.bydirection('down') end,
        { description = 'swap down', group = 'client' }
    ),
    awful.key(
        { mod }, 'k',
        function() awful.client.swap.bydirection('up') end,
        { description = 'swap up', group = 'client' }
    ),
    awful.key(
        { mod }, 'h',
        function() awful.client.swap.bydirection('left') end,
        { description = 'swap left', group = 'client' }
    ),
    awful.key(
        { mod }, 'l',
        function() awful.client.swap.bydirection('right') end,
        { description = 'swap right', group = 'client' }
    ),

    awful.key(
        { mod, ctrl }, 'j',
        function() helper.client:resize('down') end,
        { description = 'resize down', group = 'client' }
    ),
    awful.key(
        { mod, ctrl }, 'k',
        function() helper.client:resize('up') end,
        { description = 'resize up', group = 'client' }
    ),
    awful.key(
        { mod, ctrl }, 'h',
        function() helper.client:resize('left') end,
        { description = 'resize left', group = 'client' }
    ),
    awful.key(
        { mod, ctrl }, 'l',
        function() helper.client:resize('right') end,
        { description = 'resize right', group = 'client' }
    ),
}

awful.keyboard.append_global_keybindings {
    awful.key(
        {}, 'Print',
        function() helper.screenshot { auto_save_delay = 0, clipboard = true } end,
        { description = 'Screenshot', group = 'screenshot' }
    ),
    awful.key(
        { shift }, 'Print',
        function() helper.screenshot { auto_save_delay = 0, interactive = true } end,
        { description = 'Screenshot interactive', group = 'screenshot' }
    ),
    awful.key(
        { ctrl }, 'Print',
        function() helper.screenshot { auto_save_delay = 5 } end,
        { description = 'Screenshot with delay', group = 'screenshot' }
    ),
    awful.key(
        { shift, ctrl }, 'Print',
        function() helper.screenshot { auto_save_delay = 5, interactive = true } end,
        { description = 'Screenshot interactive with delay', group = 'screenshot' }
    ),
}

awful.keyboard.append_global_keybindings {
    awful.key(
        { mod, ctrl }, 't',
        helper.misc.toggle_wibar,
        { description = 'toggle wibar', group = 'misc' }
    ),
    awful.key(
        { mod }, 'v',
        function() modalbind.grab { keymap = mode.volume, name = 'volume', stay_in_mode = true } end,
        { description = 'volume mode', group = 'misc' }
    )
}


client.connect_signal('request::default_keybindings', function()
    awful.keyboard.append_client_keybindings {
        awful.key(
            { mod, 'Shift' }, 'c',
            function(c) c:kill() end,
            { description = 'close', group = 'client' }
        ),
        awful.key(
            { mod }, 'f',
            function(c) c.fullscreen = not c.fullscreen c:raise() end,
            { description = 'toggle fullscreen', group = 'client' }
        ),
        awful.key(
            { mod, ctrl }, 'space',
            function() awful.client.floating.toggle() end,
            { description = 'toggle floating', group = 'client' }
        ),
        awful.key(
            { mod }, 'o',
            function(c) c:move_to_screen() end,
            { description = 'move to screen', group = 'client' }
        ),
        awful.key(
            { mod }, 't',
            function(c) c.ontop = not c.ontop end,
            { description = 'toggle keep on top', group = 'client' }
        ),

        awful.key(
            { mod }, 'm',
            function(c) c.maximized = not c.maximized c:raise() end,
            { description = '(un)maximize', group = 'client' }
        ),
        awful.key(
            { mod, ctrl }, 'm',
            function(c) c.maximized_vertical = not c.maximized_vertical c:raise() end,
            { description = '(un)maximize vertically', group = 'client' }
        ),
        awful.key(
            { mod, shift }, 'm',
            function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end,
            { description = '(un)maximize horizontally', group = 'client' }
        ),

        awful.key(
            { mod }, 'n',
            function(c) c.minimized = true end,
            { description = 'minimize', group = 'client' }
        ),
        awful.key(
            { mod, ctrl }, 'n',
            function()
                local c = awful.client.restore()
                if c then c:activate { raise = true, context = 'key.unminimize' } end
            end,
            { description = 'restore minimized', group = 'client' }
        ),
        awful.key(
            {}, 'Print',
            function() helper.screenshot { auto_save_delay = 0, clipboard = true } end,
            { description = 'Screenshot', group = 'screenshot' }
        ),
        awful.key(
            { shift }, 'Print',
            function() helper.screenshot { auto_save_delay = 0, interactive = true } end,
            { description = 'Screenshot interactive', group = 'screenshot' }
        ),
        awful.key(
            { ctrl }, 'Print',
            function() helper.screenshot { auto_save_delay = 5 } end,
            { description = 'Screenshot with delay', group = 'screenshot' }
        ),
        awful.key(
            { shift, ctrl }, 'Print',
            function() helper.screenshot { auto_save_delay = 5, interactive = true } end,
            { description = 'Screenshot interactive with delay', group = 'screenshot' }
        ),
    }
end)
