ctx:
let
  cfg = ctx.terminal-settings "_";
in
ctx.pkgs.writeTextFile {
  destination = "/kitty.conf";
  name = "kitty-config";
  text = ''
    include ${ctx.pkgs.kitty-themes}/share/kitty-themes/themes/${cfg.theme}.conf

    font_family Iosevka Custom ${cfg.weight}
    bold_font Iosevka Custom Extrabold
    italic_font Iosevka Custom ${cfg.italic}
    bold_italic_font Iosevka Custom Extrabold Italic

    font_size ${builtins.toString cfg.font-size}

    disable_ligatures always
  '';
}
