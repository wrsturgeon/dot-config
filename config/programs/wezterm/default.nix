ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.pkgs.wezterm;
  buildPhase = ''
    for f in $(find . -type f); do
      if [ -x "$f" ]; then
        mv "$f" "$f-raw"
        echo "${''
          #!/usr/bin/env bash

          $f --config-file ${./config.lua}
        ''}" > "$f"
        chmod +x "$f"
      fi
    done
  '';
  installPhase = "cp -r . $out";
}
