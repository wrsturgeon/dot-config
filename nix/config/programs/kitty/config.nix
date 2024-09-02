ctx:
ctx.pkgs.writeTextFile {
  destination = "/kitty.conf";
  name = "kitty-config";
  text = ''
    include ${ctx.pkgs.kitty-themes}/share/kitty-themes/themes/${ctx.terminal-settings.theme}.conf

    font_family Iosevka Custom ${ctx.terminal-settings.weight}
    bold_font Iosevka Custom Extrabold
    italic_font Iosevka Custom ${ctx.terminal-settings.italic}
    bold_italic_font Iosevka Custom Extrabold Italic

    font_size ${ctx.terminal-settings.font-size}

    disable_ligatures always
  '';
}
