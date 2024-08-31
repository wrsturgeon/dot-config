ctx:
ctx.pkgs.writeTextFile {
  destination = "/kitty.conf";
  name = "kitty-config";
  text = ''
    include ${ctx.pkgs.kitty-themes}/share/kitty-themes/themes/GitHub_Dark.conf

    # font_family Iosevka Custom Light
    font_family Iosevka Custom Regular
    bold_font Iosevka Custom Extrabold
    # italic_font Iosevka Custom Light Italic
    italic_font Iosevka Custom Italic
    bold_italic_font Iosevka Custom Extrabold Italic

    font_size 13

    disable_ligatures always
  '';
}
