ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ./.;
  buildPhase = ":";
  installPhase = ''
    cp -r ${ctx.pkgs.wezterm} $out
  '';
}
