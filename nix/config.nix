{ linux-mac, nixvim, pkgs, self, system, }: {
  environment.systemPackages = with pkgs; [ nixfmt ];
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };
  nixpkgs.hostPlatform = system;
  programs = { zsh.enable = true; };
  services.nix-daemon.enable = true;
  system = { configurationRevision = self.rev or self.dirtyRev or null; };
}
