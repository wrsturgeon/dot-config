ctx: {
  packages = (with ctx; [ iosevka ]) ++ (with ctx.pkgs; [ nerdfonts ]);
}
