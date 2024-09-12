ctx: ''
  local wezterm = require 'wezterm'
  local config = {}

  config.front_end = "WebGpu"

  config.color_scheme = 'ayu' -- 'Ayu Dark (Gogh)'
  config.font = wezterm.font 'Iosevka Custom'
  config.font_size = ${ctx.linux-mac "6" "12"}
  config.hide_tab_bar_if_only_one_tab = true

  return config
''
