ctx:
{
  emacs = {
    enable = true;
    package = ctx.pkgs.emacs;
    exec = "emacs";
  };
}
// (ctx.linux-mac { } { nix-daemon.enable = true; })
