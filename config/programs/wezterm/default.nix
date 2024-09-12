ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.wezterm-zip;
  buildPhase = ":";
  # buildPhase = ''
  #   mv bin/wezterm-gui bin/wezterm-gui-raw
  #   echo "${''
  #     #!/usr/bin/env bash
  #
  #     $out/bin/wezterm-gui-raw --config-file ${./config.lua}
  #   ''}" > bin/wezterm-gui
  #   chmod +x bin/wezterm-gui
  # '';
  # installPhase = "cp -r . $out";
  installPhase = ''
    ${ctx.pkgs.tree}/bin/tree .
    mkdir -p $out/Applications
    cp -r WezTerm.app $out/Applications/WezTerm.app
    ln -s $out/Applications/WezTerm.app/Contents/MacOS $out/bin
    for f in $(find $out -name 'wezterm-gui'); do
      mv $f ''${f}-raw
      echo "${''
        #!/usr/bin/env bash
        ''${f}-raw --config-file ${./config.lua}
      ''}" > $f
    done
  '';
}
