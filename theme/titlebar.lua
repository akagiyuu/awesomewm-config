local M = {}

M.init = function(theme, titlebar_theme)
    titlebar_theme = titlebar_theme or 'stoplight'

    local titlebar_icon_path = Paths.icon .. 'titlebar/' .. titlebar_theme .. '/'
    local tip                = titlebar_icon_path

    theme.titlebar_close_button_normal       = tip .. 'close_normal.svg'
    theme.titlebar_close_button_normal_hover = tip .. 'close_normal_hover.svg'
    theme.titlebar_close_button_focus        = tip .. 'close_focus.svg'
    theme.titlebar_close_button_focus_hover  = tip .. 'close_focus_hover.svg'

    theme.titlebar_minimize_button_normal       = tip .. 'minimize_normal.svg'
    theme.titlebar_minimize_button_normal_hover = tip .. 'minimize_normal_hover.svg'
    theme.titlebar_minimize_button_focus        = tip .. 'minimize_focus.svg'
    theme.titlebar_minimize_button_focus_hover  = tip .. 'minimize_focus_hover.svg'

    theme.titlebar_ontop_button_normal_inactive = tip .. 'ontop_normal_inactive.svg'
    theme.titlebar_ontop_button_focus_inactive  = tip .. 'ontop_focus_inactive.svg'
    theme.titlebar_ontop_button_normal_active   = tip .. 'ontop_normal_active.svg'
    theme.titlebar_ontop_button_focus_active    = tip .. 'ontop_focus_active.svg'

    theme.titlebar_sticky_button_normal_inactive = tip .. 'sticky_normal_inactive.svg'
    theme.titlebar_sticky_button_focus_inactive  = tip .. 'sticky_focus_inactive.svg'
    theme.titlebar_sticky_button_normal_active   = tip .. 'sticky_normal_active.svg'
    theme.titlebar_sticky_button_focus_active    = tip .. 'sticky_focus_active.svg'

    theme.titlebar_floating_button_normal_inactive = tip .. 'floating_normal_inactive.svg'
    theme.titlebar_floating_button_focus_inactive  = tip .. 'floating_focus_inactive.svg'
    theme.titlebar_floating_button_normal_active   = tip .. 'floating_normal_active.svg'
    theme.titlebar_floating_button_focus_active    = tip .. 'titlebar/stoplight/floating_focus_active.svg'

    theme.titlebar_maximized_button_normal_inactive = tip .. 'maximized_normal_inactive.svg'
    theme.titlebar_maximized_button_focus_inactive  = tip .. 'maximized_focus_inactive.svg'
    theme.titlebar_maximized_button_normal_active   = tip .. 'maximized_normal_active.svg'
    theme.titlebar_maximized_button_focus_active    = tip .. 'maximized_focus_active.svg'

    theme.titlebar_ontop_button_normal_inactive_hover = tip .. 'ontop_normal_inactive_hover.svg'
    theme.titlebar_ontop_button_focus_inactive_hover  = tip .. 'ontop_focus_inactive_hover.svg'
    theme.titlebar_ontop_button_normal_active_hover   = tip .. 'ontop_normal_active_hover.svg'
    theme.titlebar_ontop_button_focus_active_hover    = tip .. 'ontop_focus_active_hover.svg'

    theme.titlebar_sticky_button_normal_inactive_hover = tip .. 'sticky_normal_inactive_hover.svg'
    theme.titlebar_sticky_button_focus_inactive_hover  = tip .. 'sticky_focus_inactive_hover.svg'
    theme.titlebar_sticky_button_normal_active_hover   = tip .. 'sticky_normal_active_hover.svg'
    theme.titlebar_sticky_button_focus_active_hover    = tip .. 'sticky_focus_active_hover.svg'

    theme.titlebar_floating_button_normal_inactive_hover = tip .. 'floating_normal_inactive_hover.svg'
    theme.titlebar_floating_button_focus_inactive_hover  = tip .. 'floating_focus_inactive_hover.svg'
    theme.titlebar_floating_button_normal_active_hover   = tip .. 'floating_normal_active_hover.svg'
    theme.titlebar_floating_button_focus_active_hover    = tip .. 'floating_focus_active_hover.svg'

    theme.titlebar_maximized_button_normal_inactive_hover = tip .. 'maximized_normal_inactive_hover.svg'
    theme.titlebar_maximized_button_focus_inactive_hover  = tip .. 'maximized_focus_inactive_hover.svg'
    theme.titlebar_maximized_button_normal_active_hover   = tip .. 'maximized_normal_active_hover.svg'
    theme.titlebar_maximized_button_focus_active_hover    = tip .. 'maximized_focus_active_hover.svg'
end

return M
