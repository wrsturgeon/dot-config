ctx:
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
              iosevka = "${ctx.iosevka}/share/fonts/truetype/Iosevkacustom-Regular.ttf";
            in
            ''
              ${cfg.installPhase}
              cp ${iosevka} ./fonts/SymbolsNerdFontMono-Regular.ttf
              cp ${iosevka} $out/Applications/kitty.app/Contents/Resources/kitty/fonts/SymbolsNerdFontMono-Regular.ttf
              sed -i 's|"$@"|"--config" "${ctx.kitty-config}/kitty.conf" "$@"|' $(find $out -name kitty)
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
