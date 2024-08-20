{ laptop-name, linux-mac, nixvim, pkgs, self, system, }: {
  etc = {
    gitignore.text = ''
      **/.DS_Store
    '';
  };
  extraInit = ''
    echo 'Hello from `extraInit`!'
  '';
  extraSetup = ''
    echo 'Hello from `extraSetup`!'
    ls $out
  '';
  pathsToLink = [ "/share/zsh" ];
  systemPackages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    # wezterm
  ];
  variables = {
    EDITOR = "vim";
    LANG = "fr_FR.UTF-8";
  };
}
