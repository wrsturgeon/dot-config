{
  laptop-name,
  linux-mac,
  nixvim,
  pkgs,
  self,
  system,
}:
{
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
    cargo
    coreutils-full
    discord
    fd
    gcc
    gimp
    gnumake
    nil
    rss2email
    rust-analyzer
    rustfmt
    slack
    spotify
    taplo
    zoom-us
    kitty
    nixfmt-rfc-style
    ripgrep
    # wezterm
  ];
  variables = {
    EDITOR = "vim";
    LANG = "fr_FR.UTF-8";
  };
}
