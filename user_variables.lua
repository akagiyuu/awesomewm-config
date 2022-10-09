local awful = require("awful")

Terminal  = "kitty"
Editor    = os.getenv("EDITOR") or "nvim"
EditorCmd = Terminal .. " -e " .. Editor

Paths = {
    home = os.getenv("HOME"),
    config_directory = awful.util.getdir("config"),
}

Paths.icon     = Paths.config_directory .. "assets/icons/"
Paths.app_icon = Paths.home .. '/.local/share/icons/Papirus/64x64/apps/'
