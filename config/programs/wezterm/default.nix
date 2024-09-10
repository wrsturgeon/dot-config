ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ./.;
  buildPhase = ":";
  installPhase = ''
    cp -r ${ctx.pkgs.wezterm} $out
    for f in $(find $out -name 'wezterm'); do
      mv $f $f-raw
      echo "${''
        #!/usr/bin/env bash

        $f --config-file ${./config.lua}
      ''}" > $f
    done
  '';
}
