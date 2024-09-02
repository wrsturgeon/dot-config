ctx:
ctx.pkgs.writeTextFile {
  destination = "/kitty.conf";
  name = "kitty-config";
  text = ''
    include ${ctx.pkgs.kitty-themes}/share/kitty-themes/themes/${ctx.kitty-settings.theme}.conf

    font_family Iosevka Custom ${ctx.kitty-settings.weight}
    bold_font Iosevka Custom Extrabold
    italic_font Iosevka Custom ${ctx.kitty-settings.italic}
    bold_italic_font Iosevka Custom Extrabold Italic

    font_size 13

    disable_ligatures always
  '';
}
