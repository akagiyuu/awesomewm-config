local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

local dpi = beautiful.xresources.apply_dpi

----- Dashboard Setup -----

local description = ""

local box_gap = dpi(10)

local dashboard = wibox {
	visible = false,
	ontop = true,
	bg = colors.transparent,
}

awful.placement.maximize(dashboard)

local keylock = awful.keygrabber {
	autostart = false,
	stop_event = 'release',
	keypressed_callback = function(_, _, key, _)
		if key == "Escape" then
			awesome.emit_signal("dashboard::toggle")
		end
	end
}


----- Function ------

-- Rounded Rectangle
local rr = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, 10)
end

-- Vertical padding
local v_pad = function(pad)
	local v_padding = wibox.layout.fixed.horizontal()
	v_padding.forced_height = dpi(pad)

	return v_padding
end

-- Coloring
local coloring_text = function(text, color)
	color = color or beautiful.fg_normal
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

-- Create box function
local crt_box = function(widget, width, height, bg)
	local container = wibox.container.background()
	container.bg = bg
	container.forced_width = width
	container.forced_height = height
	container.border_width = dpi(4)
	container.border_color = beautiful.bar_alt
	container.shape = rr
	container.opacity = 0.7

	local box_widget = wibox.widget {
		{
			{
				nil,
				{
					nil,
					widget,
					expand = 'none',
					layout = wibox.layout.align.horizontal,
				},
				expand = 'none',
				layout = wibox.layout.align.vertical,
			},
			widget = container,
		},
		margins = box_gap,
		widget = wibox.container.margin,
	}

	return box_widget
end

----- Var -----

-- Profile Widget
local pfp = wibox.widget {
	{
		image = beautiful.profile_picture,
		halign = 'center',
		widget = wibox.widget.imagebox,
	},
	forced_width = dpi(200),
	forced_height = dpi(200),
	shape = gears.shape.circle,
	widget = wibox.container.background,
}

local user_widget = wibox.widget.textbox()
local desc_widget = wibox.widget.textbox()

user_widget.font = beautiful.font_name .. " bold 38"
user_widget.align = 'center'
user_widget.markup = coloring_text(os.getenv('USER'), colors.red)

desc_widget.font = beautiful.font_name .. " 16"
desc_widget.align = 'center'
desc_widget.markup = description

local profile_widget = wibox.widget {
	{
		nil,
		{
			pfp,
			v_pad(20),
			user_widget,
			desc_widget,
			spacing = dpi(20),
			layout = wibox.layout.fixed.vertical,
		},
		expand = 'none',
		layout = wibox.layout.align.horizontal,
	},
	margins = dpi(12),
	widget = wibox.container.margin,
}

local profile = crt_box(profile_widget, 360, 460, colors.black)

-- Clock Widget
local time = wibox.widget.textbox()
time.font = beautiful.font_name .. " bold 42"
time.align = 'center'

local date = wibox.widget.textbox()
date.font = beautiful.font_name .. " 16"
date.align = 'center'

local am = wibox.widget.textbox()
local pm = wibox.widget.textbox()
am.font = beautiful.font_name .. " bold 36"
pm.font = beautiful.font_name .. " bold 36"
am.align = 'center'
pm.align = 'center'
am.valign = 'center'
pm.valign = 'center'

local updt_ampm = function()
	tmp = os.date("%p")
	if tmp == "AM" then
		am.markup = coloring_text("AM", colors.yellow)
		pm.markup = coloring_text("PM", colors.brightblack)
	else
		am.markup = coloring_text("AM", colors.brightblack)
		pm.markup = coloring_text("PM", colors.blue)
	end
end

local ampm_widget = wibox.widget {
	nil,
	{
		am,
		pm,
		spacing = dpi(5),
		layout = wibox.layout.fixed.vertical,
	},
	expand = 'none',
	layout = wibox.layout.align.vertical,
}

gears.timer {
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		time.markup = coloring_text(os.date("%R"), colors.green)
		date.markup = coloring_text(os.date("%d %B, %Y"))
		updt_ampm()
	end
}

local clock_widget = wibox.widget {
	time,
	ampm_widget,
	spacing = dpi(24),
	layout = wibox.layout.fixed.horizontal,
}

local clock = crt_box(clock_widget, 360, 200, colors.black)

-- Calendar
local styles = {}

styles.month = {
	padding = dpi(20),
	bg_color = colors.transparent,
	fg_color = colors.blue,
	border_width = dpi(0)
}
styles.normal = { shape = rr }
styles.focus = {
	fg_color = colors.yellow,
	bg_color = colors.transparent,
	markup = function(t) return '<b>' .. t .. '</b>' end
}
styles.header = {
	fg_color = colors.red,
	markup = function(t) return '<span font_desc= ' .. beautiful.font_name .. ' bold 20">' .. t .. '</span>' end
}
styles.weekday = {
	bg_color = colors.transparent,
	fg_color = colors.blue,
	padding  = dpi(3),
	markup   = function(t) return '<b>' .. t .. '</b>' end
}

local function decorate_cell(widget, flag, date)
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_bg = colors.transparent
	local ret = wibox.widget {
		{
			widget,
			margins = (props.padding or 2) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		shape        = props.shape,
		border_color = props.border_color or colors.brightblack,
		border_width = props.border_width or 0,
		fg           = props.fg_color or "#999999",
		bg           = props.bg_color or default_bg,
		widget       = wibox.container.background
	}

	return ret
end

local calendar_widget = wibox.widget {
	date = os.date('*t'),
	font = beautiful.font_name .. " 16",
	spacing = dpi(10),
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month
}

local calendar = crt_box(calendar_widget, 300, 400, colors.black)

-- Uptime
local uptime_text = wibox.widget.textbox()
local uptime_icon = wibox.widget.textbox()
uptime_text.font = beautiful.font_name .. " 16"
uptime_text.align = 'center'
uptime_icon.font = beautiful.font_name .. " 42"
uptime_icon.align = 'center'
uptime_icon.markup = coloring_text("", colors.blue)

gears.timer {
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		script = io.popen('uptime -p')
		upfor = tostring(script:read('*a'))
		upfor = string.gsub(upfor, '\n', '')
		uptime_text.markup = coloring_text(upfor)
	end
}

local uptime_widget = wibox.widget {
	uptime_icon,
	uptime_text,
	spacing = dpi(10),
	layout = wibox.layout.fixed.vertical,
}

local uptime = crt_box(uptime_widget, 400, 140, colors.black)

-- Stats
local volume_icon = wibox.widget.textbox()
local bright_icon = wibox.widget.textbox()

volume_icon.font = beautiful.icon_font .. " 40"
bright_icon.font = beautiful.icon_font .. " 40"

volume_icon.markup = coloring_text("󰋋", colors.blue)
bright_icon.markup = coloring_text("", colors.yellow)

local volume_slider = wibox.widget {
	{
		id = 'slider',
		max_value = 100,
		color = colors.blue,
		background_color = colors.brightblack,
		shape = gears.shape.rounded_bar,
		bar_shape = gears.shape.rounded_bar,
		widget = wibox.widget.progressbar,
	},
	forced_width = dpi(5),
	forced_height = dpi(150),
	direction = "east",
	widget = wibox.container.rotate,
}

local bright_slider = wibox.widget {
	{
		id = 'slider',
		max_value = 80,
		color = colors.yellow,
		background_color = colors.brightblack,
		shape = gears.shape.rounded_bar,
		bar_shape = gears.shape.rounded_bar,
		widget = wibox.widget.progressbar,
	},
	forced_width = dpi(5),
	forced_height = dpi(150),
	direction = "east",
	widget = wibox.container.rotate,
}

local stats_widget = wibox.widget {
	{
		{
			volume_slider,
			margins = { left = dpi(20), right = dpi(20) },
			widget = wibox.container.margin,
		},
		volume_icon,
		spacing = dpi(10),
		layout = wibox.layout.fixed.vertical,
	},
	{
		{
			bright_slider,
			margins = { left = dpi(20), right = dpi(20) },
			widget = wibox.container.margin,
		},
		bright_icon,
		spacing = dpi(10),
		layout = wibox.layout.fixed.vertical,
	},
	spacing = dpi(20),
	layout = wibox.layout.fixed.horizontal,
}

local stats = crt_box(stats_widget, 200, 300, colors.black)

-- Disk
local disk_text = wibox.widget.textbox()
disk_text.font = beautiful.font_name .. " 46"
disk_text.markup = coloring_text("", colors.brightblack)
disk_text.align = 'center'
disk_text.valign = 'center'

local disk_bar = wibox.widget {
	{
		id = 'bar',
		color = colors.red,
		background_color = colors.black,
		widget = wibox.widget.progressbar,
	},
	direction = 'east',
	widget = wibox.container.rotate,
}

local get_disk = function()
	script = [[
	df -kH -B 1MB /dev/sdb2 | tail -1 | awk '{printf "%d|%d" ,$2, $3}'
	]]
	awful.spawn.easy_async_with_shell(script, function(stdout)
		local disk_total = stdout:match('(%d+)[|]')
		disk_total = disk_total / 1000
		local disk_available = stdout:match('%d+[|](%d+)')
		disk_available = disk_available / 1000

		awesome.emit_signal("signal::disk", disk_total, disk_available)
	end)
end

gears.timer {
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		get_disk()
	end
}

awesome.connect_signal("signal::disk", function(disk_total, disk_available)
	disk_bar:get_children_by_id('bar')[1].value = disk_available
	disk_bar:get_children_by_id('bar')[1].max_value = disk_total
end)

local disk_widget = wibox.widget {
	disk_bar,
	{
		nil,
		disk_text,
		expand = 'none',
		layout = wibox.layout.align.vertical,
	},
	layout = wibox.layout.stack,
}

local disk = crt_box(disk_widget, 100, 300, colors.black)

-- Weather
local temperature = wibox.widget.textbox()
temperature.font = beautiful.font_name .. " bold 20"
temperature.align = 'center'

local how = wibox.widget.textbox()
how.font = beautiful.font_name .. " 18"
how.align = 'center'

local weather_icon = wibox.widget.textbox()
weather_icon.font = beautiful.font_name .. " 72"
weather_icon.align = 'center'

local get_weather = function()
	awful.spawn.easy_async_with_shell("curl 'wttr.in/?format=%t,%C,%c,'",
		function(stdout)
			local data = {}
			for w in stdout:gmatch("(.-),") do table.insert(data, w) end
			local temp = data[1]:sub(2)
			local how  = data[2]
			local icon = data[3]:gsub("%s+", "")

			awesome.emit_signal("signal::weather", temp, icon, how)
		end
	)
end

gears.timer {
	timeout = 600,
	autostart = true,
	call_now = true,
	callback = function()
		get_weather()
	end
}
awesome.connect_signal('signal::weather', function(temp, icon, what)
	temperature.markup = coloring_text(temp, colors.yellow)
	how.markup = coloring_text(what, beautiful.fg_normal)
	weather_icon.markup = coloring_text(icon, beautiful.fg_normal)
end)

local weather_widget = wibox.widget {
	weather_icon,
	{
		{
			temperature,
			how,
			widget = wibox.layout.fixed.vertical,
		},
		align = 'center',
		valign = 'center',
		widget = wibox.container.place,
	},
	spacing = dpi(10),
	layout = wibox.layout.fixed.horizontal,
}

local weather = crt_box(weather_widget, 300, 300, colors.black)

dashboard:setup {
	nil,
	{
		nil,
		{
			{
				profile,
				uptime,
				layout = wibox.layout.fixed.vertical,
			},
			{
				clock,
				calendar,
				layout = wibox.layout.fixed.vertical,
			},
			{
				weather,
				{
					stats,
					disk,
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.fixed.vertical,
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		expand = 'none',
		layout = wibox.layout.align.vertical,
	},
	expand = 'none',
	layout = wibox.layout.align.horizontal,
}

local toggle = function()
	if dashboard.visible then
		keylock:stop()
	else
		keylock:start()
	end
	dashboard.visible = not dashboard.visible
end

dashboard:buttons(gears.table.join(awful.button({}, 3, function() toggle() end)))

awesome.connect_signal("dashboard::toggle", function() toggle() end)
