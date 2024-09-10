ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.pkgs.wezterm;
  buildPhase = ''
    for f in $(find . -name 'wezterm'); do
      mv $f $f-raw
      echo "${''
        #!/usr/bin/env bash

        $f --config-file ${./config.lua}
      ''}" > $f
    done
  '';
  installPhase = "cp -r . $out";
}
