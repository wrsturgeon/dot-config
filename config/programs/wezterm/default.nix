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
    cp ./WezTerm.app $out/Applications/WezTerm.app
    mkdir -p $out/bin
    echo "${''
      #!/usr/bin/env bash

      $out/bin/wezterm-gui-raw --config-file ${./config.lua}
    ''}" > bin/wezterm-gui
  '';
}
