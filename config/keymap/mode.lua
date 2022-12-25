local awful = require('awful')

return {
    volume = {
        {
            'd',
            function() awesome.emit_signal('signal::volume') awful.util.spawn('pamixer -d 6', false) end,
            'decrease volume',
        },
        {
            'u',
            function() awesome.emit_signal('signal::volume') awful.util.spawn('pamixer -i 6', false) end,
            'increase volume',
        },
        {
            'XF87AudioMute',
            function() awful.util.spawn('pamixer -t', false) end,
            'toggle mute',
        },
    }
}
