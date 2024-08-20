{
  linux-mac,
  nixfmt,
  nixvim,
  pkgs,
  self,
  stateVersion,
  system,
}:
{
  environment.systemPackages=(builtins.map (p: p.packages.${system}.default) [nixfmt]);
  nix={package=pkgs.nix;settings.experimental-features="nix-command flakes";};
  nixpkgs.hostPlatform=system;
  programs={zsh.enable=true;};
  services.nix-daemon.enable = true;
  system={inherit stateVersion;configurationRevision = self.rev or self.dirtyRev or null;
};
}
