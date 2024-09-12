ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.wezterm-zip;
  buildPhase = ''
    pwd
    ${ctx.pkgs.tree}/bin/tree -a .
    mv bin/wezterm-gui bin/wezterm-gui-raw
    echo "${''
      #!/usr/bin/env bash

      $out/bin/wezterm-gui-raw --config-file ${./config.lua}
    ''}" > bin/wezterm-gui
    chmod +x bin/wezterm-gui
  '';
  installPhase = "cp -r . $out";
}
