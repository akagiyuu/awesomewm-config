local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi
local gears = require('gears')

local layout_icon_path = Paths.icon .. 'layouts/'
local lip              = layout_icon_path

local others_icon_path = Paths.icon .. 'others/'
local oip              = others_icon_path

local default_theme = {
    font_name            = 'Cascadia Code',
    icon_font            = 'Material Icon Design',
    font                 = 'Cascadia Code Italic 10',
    taglist_font         = 'Material Icon Design 12',
    bg_normal            = colors.brightblack,
    bg_focus             = colors.brightblack,
    bg_urgent            = colors.black,
    bg_minimize          = colors.black,
    bg_systray           = colors.black,
    systray_icon_spacing = dpi(4),
    wallpaper            = Paths.config_directory .. 'assets/wallpaper.jpg',
    profile_picture      = Paths.config_directory .. 'assets/profile.jpg',

    taglist_spacing   = dpi(2),
    taglist_bg_focus  = colors.black,
    -- taglist_fg_focus  = colors.blue,
    taglist_fg_empty  = colors.brightblack,
    taglist_bg_empty  = colors.black,
    taglist_fg_urgent = colors.green,

    fg_normal   = colors.white,
    -- fg_focus          = colors.blue,
    fg_urgent   = colors.brightred,
    fg_minimize = colors.brightblack,

    useless_gap       = dpi(5),
    border_width      = dpi(2),
    gap_single_client = false,
    border_normal     = colors.brightblack,
    -- border_focus      = colors.blue,
    -- border_marked     = colors.blue,
    corner_radius     = dpi(5),
    border_radius     = dpi(5),

    hotkeys_bg           = colors.black .. '33',
    hotkeys_modifiers_fg = colors.blue,
    tasklist_bg_normal   = colors.black,

    tasklist_bg_focus          = colors.blue,
    tasklist_bg_urgent         = colors.green,
    tasklist_plain_task_name   = true,
    tasklist_disable_task_name = false,
    tasklist_disable_icon      = true,

    notification_position             = 'top_right',
    notification_bg                   = colors.black .. '00',
    notification_margin               = dpi(10),
    notification_border_width         = dpi(10),
    -- notification_border_color         = colors.blue,
    notification_spacing              = dpi(10),
    notification_icon_resize_strategy = 'center',
    notification_icon_size            = dpi(32),

    -- menu_submenu_icon = oip .. 'forward.png',
    -- menu_bg_normal    = colors.black,
    -- menu_bg_focus     = colors.black,
    -- -- menu_border_color = colors.blue,
    -- menu_border_width = dpi(2),
    -- menu_height       = dpi(20),
    -- menu_width        = dpi(170),

    awesome_icon = Paths.icon .. 'arch/archlinux.png',
    icon_theme   = '/usr/share/icons/Papirus-Dark/16x16/apps',

    titlebar_size      = dpi(20),
    titlebar_position  = 'left',
    titlebar_bg_focus  = colors.black,
    titlebar_bg_normal = colors.black,
    -- titlebar_fg_focus  = colors.blue,

    layout_fairh      = lip .. 'fairh.png',
    layout_fairv      = lip .. 'fairv.png',
    layout_floating   = lip .. 'floating.png',
    layout_magnifier  = lip .. 'magnifier.png',
    layout_max        = lip .. 'max.png',
    layout_fullscreen = lip .. 'fullscreen.png',
    layout_tilebottom = lip .. 'tilebottom.png',
    layout_tileleft   = lip .. 'tileleft.png',
    layout_tile       = lip .. 'tile.png',
    layout_tiletop    = lip .. 'tiletop.png',
    layout_spiral     = lip .. 'spiral.png',
    layout_dwindle    = lip .. 'dwindle.png',
    layout_cornernw   = lip .. 'cornernww.png',
    layout_cornerne   = lip .. 'cornerne.png',
    layout_cornersw   = lip .. 'cornersw.png',
    layout_cornerse   = lip .. 'cornerse.png',

    powermenu_fg_normal = colors.black,

    flash_focus_start_opacity = 0.8,
    flash_focus_step          = 0.01,

    -- collision_focus_bg_center = colors.black,
    -- collision_resize_shape = gears.shape.rectangle,
    -- collision_resize_size_shape = gears.shape.rectangle,
    -- collision_focus_shape = gears.shape.rectangle,
    -- collision_focus_fg = colors.blue,
    -- collision_focus_bg = colors.transparent,
    modalbind_font = 'Cascadia Code Italic 9',
    modebox_fg = colors.brightwhite,
    modebox_bg = colors.black
}

default_theme.window_switcher_widget_bg = '#00000000'
default_theme.window_switcher_widget_border_color = default_theme.border_focus
default_theme.window_switcher_name_font = default_theme.font
default_theme.window_switcher_name_normal_color = default_theme.fg_normal
default_theme.window_switcher_name_focus_color = default_theme.fg_focus
default_theme.window_switcher_widget_border_radius = default_theme.corner_radius

return default_theme
