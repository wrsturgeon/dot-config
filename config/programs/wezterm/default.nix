ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.linux-mac ctx.pkgs.wezterm ctx.wezterm-zip;
  buildPhase = ":";
  installPhase = ''
    ${ctx.linux-mac
      ''
        cp -r . $out
      ''
      ''
        mkdir -p $out/Applications
        cp -r WezTerm.app $out/Applications/WezTerm.app
        ln -s $out/Applications/WezTerm.app/Contents/MacOS $out/bin
      ''
    }
    for f in $(find $out -name 'wezterm-gui'); do
      mv $f ''${f}-raw
      echo "${''
        #!/usr/bin/env bash
        ''${f}-raw --config-file ${./config.lua}
      ''}" > $f
      chmod +x $f
    done
  '';
}
