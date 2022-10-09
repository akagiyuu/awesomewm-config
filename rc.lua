pcall(require, "luarocks.loader")
require("awful.autofocus")
require("user_variables")

require("themes").init {
    accent = "ayu",
}

require("configuration")
require("ui")
require("modules")
