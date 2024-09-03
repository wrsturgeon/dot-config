ctx:
let
  firmware = ctx.pkgs.stdenvNoCC.mkDerivation {
    pname = "brcm-firmware";
    version = "none";
    buildCommand = ''
      dir="$out/lib/firmware"
      mkdir -p "$dir"
      cp -r ${./firmware}/* "$dir"
    '';
  };
in ctx.linux-mac { firmware = [ firmware ]; } null
