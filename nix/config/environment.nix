{ linux-mac, nixvim, pkgs, self, system, }: {
  systemPackages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    # wezterm # when it's working
  ];
}
