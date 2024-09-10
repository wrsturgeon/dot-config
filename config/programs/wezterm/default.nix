ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  name = "wezterm-configured";
  src = ./.;
  buildPhase = ":";
  installPhase = ''
    mv ${ctx.pkgs.wezterm} $out
  '';
}
