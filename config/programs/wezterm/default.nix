ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ctx.pkgs.wezterm;
  # buildPhase = ''
  #   for f in $(find . -type f); do
  #     if [ -x "$f" ]; then
  #       mv "$f" "$f-raw"
  #       echo "${''
  #         #!/usr/bin/env bash
  #
  #         $out/$f --config-file ${./config.lua}
  #       ''}" > "$f"
  #       chmod +x "$f"
  #     fi
  #   done
  # '';
  buildPhase = ''
    mv bin/wezterm-gui bin/wezterm-gui-raw
    echo "${''
      #!/usr/bin/env bash

      $out/bin/wezterm-gui-raw --config-file ${./config.lua}
    ''}" > bin/wezterm-gui
    chmod +x bin/wezterm-gui
  '';
  installPhase = "cp -r . $out";
}
