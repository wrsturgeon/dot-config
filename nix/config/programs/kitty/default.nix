ctx:
let
  cfg = ctx.terminal-settings "_";
in
ctx.pkgs.kitty.override {
  python3Packages = ctx.pkgs.python3Packages // {
    buildPythonApplication =
      instructions:
      ctx.pkgs.python3Packages.buildPythonApplication (
        instructions
        // {
          configurePhase = ''
            ${instructions.configurePhase}
            sed -i 's/raise SystemExit.*font.*was not found on your system, please install it.*/return/g' setup.py
          '';
          installPhase =
            let
              iosevka = "${ctx.iosevka}/share/fonts/truetype/Iosevkacustom-${cfg.weight}.ttf";
            in
            ''
              ${instructions.installPhase}
              cp ${iosevka} ./fonts/SymbolsNerdFontMono-${cfg.weight}.ttf
              cp ${iosevka} $out/Applications/kitty.app/Contents/Resources/kitty/fonts/SymbolsNerdFontMono-Regular.ttf
              for f in $(find $out -name kitty); do
                sed -i 's|"$@"|"--config" "${ctx.kitty-config}/kitty.conf" "$@"|' $f || echo "Couldn't add --config to $f"
              done
            '';
          nativeBuildInputs =
            instructions.nativeBuildInputs
            ++ (with ctx.pkgs.python3Packages; [
              matplotlib
            ]);
        }
      );
  };
}
