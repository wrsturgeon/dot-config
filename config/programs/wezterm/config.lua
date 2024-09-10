local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'ayu' -- 'Ayu Dark (Gogh)'
config.font = wezterm.font 'Iosevka Custom'
config.font_size = 13
config.front_end = "WebGpu"

return config
