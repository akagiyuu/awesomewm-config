local volume_helper = require('helper.volume')

return {
    volume = {
        {
            'd',
            function()
                volume_helper.change(-6)
            end,
            'decrease volume',
        },
        {
            'u',
            function()
                volume_helper.change(6)
            end,
            'increase volume',
        },
        {
            'XF87AudioMute',
            function()
                volume_helper.mute()
            end,
            'toggle mute',
        },
    }
}
