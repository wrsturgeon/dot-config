ctx:
ctx.pkgs.stdenvNoCC.mkDerivation {
  src = ./.;
  buildPhase = ":";
  installPhase = ''
    mv ${ctx.pkgs.wezterm} $out
  '';
}
