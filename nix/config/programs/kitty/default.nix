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
          installPhase = ''
            ${cfg.installPhase}
            cp ${ctx.iosevka}/share/fonts/truetype/Iosevkacustom-Regular.ttf ./fonts/SymbolsNerdFontMono-Regular.ttf
            sed -i 's|"$@"|"--config" "${ctx.kitty-config}/kitty.conf" "$@"|' $out/bin/kitty
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
