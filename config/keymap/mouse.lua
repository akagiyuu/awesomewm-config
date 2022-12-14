local awful = require('awful')
local helper = require('helper')

root.buttons {
    awful.button({}, 3, function() awful.spawn('jgmenu') end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
}

client.connect_signal('request::default_mousebindings', function()
    awful.mouse.append_client_mousebindings({
        awful.button(
            {}, 1,
            function(c) c:activate { context = 'mouse_click' } end
        ),
        awful.button(
            { mod }, 1,
            function(c) c:activate { context = 'mouse_click', action = 'mouse_move' } end
        ),
        awful.button(
            { mod, shift }, 1,
            function(c) c:activate { context = 'mouse_click', action = 'mouse_resize' } end
        ),
        awful.button(
            { ctrl, shift }, 1,
            function(client) helper.misc.send_click(client, "3") end,
            { description = 'Right click', group = 'launcher' }
        ),
    })
end)

client.connect_signal('mouse::enter', function(c)
    c:activate { context = 'mouse_enter', raise = false }
end)
