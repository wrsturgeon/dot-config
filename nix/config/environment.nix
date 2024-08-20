{ laptop-name, linux-mac, nixvim, pkgs, self, system, }: {
  etc = {
    gitignore.text = ''
      **/.DS_Store
    '';
  };
  extraInit = ''
    echo 'Hello from `extraInit`!'
  '';
  pathsToLink = [ "/share/zsh" ];
  systemPackages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    # wezterm
  ];
  variables.LANG = "fr_FR.UTF-8";
}
