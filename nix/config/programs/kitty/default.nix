orig-ctx:
let
  kitty-settings = rec {
    dark = true;
    # weight = if dark then "Light" else "Regular";
    # italic = if dark then "Light Italic" else "Italic";
    weight = "Regular";
    italic = "Italic";
    theme = "ayu-${if dark then "dark" else "light"}";
  };
  ctx = orig-ctx // {
    inherit kitty-settings;
  };
in
ctx.pkgs.kitty.override {
  python3Packages = ctx.pkgs.python3Packages // {
    buildPythonApplication =
      cfg:
      ctx.pkgs.python3Packages.buildPythonApplication (
        cfg
        // {
          configurePhase = ''
            ${cfg.configurePhase}
            sed -i 's/raise SystemExit.*font.*was not found on your system, please install it.*/return/g' setup.py
          '';
          installPhase =
            let
              iosevka = "${ctx.iosevka}/share/fonts/truetype/Iosevkacustom-${kitty-settings.weight}.ttf";
            in
            ''
              ${cfg.installPhase}
              cp ${iosevka} ./fonts/SymbolsNerdFontMono-${kitty-settings.weight}.ttf
              cp ${iosevka} $out/Applications/kitty.app/Contents/Resources/kitty/fonts/SymbolsNerdFontMono-Regular.ttf
              for f in $(find $out -name kitty); do
                sed -i 's|"$@"|"--config" "${ctx.kitty-config}/kitty.conf" "$@"|' $f || echo "Couldn't add --config to $f"
              done
            '';
          nativeBuildInputs =
            cfg.nativeBuildInputs
            ++ (with ctx.pkgs.python3Packages; [
              matplotlib
            ]);
        }
      );
  };
}
