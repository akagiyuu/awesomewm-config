local naughty = require("naughty")
local rnotification = require("ruled.notification")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "An error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)

rnotification.connect_signal("request::rules", function()
    rnotification.append_rule {
        rule       = { urgency = "critical" },
        properties = { fg = colors.red }
    }
end)

naughty.connect_signal('request::display', require('ui.notification.popup'))
