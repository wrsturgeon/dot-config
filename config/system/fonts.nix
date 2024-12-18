ctx: {
  packages =
    (with ctx; [ iosevka ])
    ++ (builtins.filter ctx.pkgs.lib.attrsets.isDerivation (builtins.attrValues ctx.pkgs.nerd-fonts));
}
