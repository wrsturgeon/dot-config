# Copied from <https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/iosevka/default.nix> branch `nixos-unstable` commit 46a4adb

ctx:
let
  privateBuildPlan = {
    exportGlyphNames = true;
    family = "Iosevka Custom";
    # <https://github.com/be5invis/Iosevka?tab=readme-ov-file#ligations>
    ligations = {
      # enable all those not enabled by `dlig` below
      # (see the above link for a visual depiction):
      enables = [
        "eqexeq"
        "eqslasheq"
        "slasheq"
        "tildeeq"
      ];
      inherits = "dlig";
    };
    noCvSs = false;
    noLigation = false;
    spacing = "fontconfig-mono";
    variants.inherits = "ss08";
    webfontFormats = [ ]; # i.e. none
  };
  set = "custom";
  pname = "iosevka";
in

ctx.pkgs.buildNpmPackage rec {
  inherit pname;
  version = "custom"; # don't try this at home
  src = ctx.iosevka-src;
  # npmDepsHash = "sha256-bhj5q3HEtSdB5LA6IhBCo4XJwc6a3CUrHaV+d1vcj+I=";
  # nativeBuildInputs =
  #   [
  #     remarshal
  #     ttfautohint-nox
  #   ]
  #   ++ lib.optionals stdenv.isDarwin [
  #     # libtool
  #     cctools
  #   ];
  buildPlan = builtins.toJSON { buildPlans.${pname} = privateBuildPlan; };

  passAsFile =
    [ "extraParameters" ]
    ++ ctx.pkgs.lib.optionals (
      !(builtins.isString privateBuildPlan && ctx.pkgs.lib.hasPrefix builtins.storeDir privateBuildPlan)
    ) [ "buildPlan" ];

  configurePhase = ''
    runHook preConfigure
    ${ctx.pkgs.lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${ctx.pkgs.lib.optionalString
      (builtins.isString privateBuildPlan && (!ctx.pkgs.lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlanPath" private-build-plans.toml
      ''
    }
    ${ctx.pkgs.lib.optionalString
      (builtins.isString privateBuildPlan && (ctx.pkgs.lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlan" private-build-plans.toml
      ''
    }
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets ttf::$pname -- --jCmd=$NIX_BUILD_CORES --verbose=9
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/TTF"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;
}
