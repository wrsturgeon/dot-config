ctx:
{
  emacs = {
    enable = true;
    package = ctx.emacs;
    exec = "emacs";
  };
}
// (ctx.linux-mac { } { nix-daemon.enable = true; })
