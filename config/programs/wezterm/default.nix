ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ./.;
  buildPhase = ''
    cp -r ${ctx.pkgs.wezterm} $out
    for f in $(find $out -name 'wezterm'); do
      cp $f $f-raw
      rm $f
      echo "${''
        #!/usr/bin/env bash

        $f --config-file ${./config.lua}
      ''}" > $f
    done
  '';
}
