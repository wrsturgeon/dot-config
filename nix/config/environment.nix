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
  systemPackages =
    (with pkgs; [
      cargo
      coreutils-full
      discord
      fd
      gcc
      gimp
      gnumake
      kitty
      nil
      nixfmt-rfc-style
      ripgrep
      rss2email
      rust-analyzer
      rustfmt
      slack
      spotify
      taplo
      # wezterm
      zoom-us
    ])
    ++ (with pkgs.coqPackages; [ coq ]);
  variables = {
    EDITOR = "vim";
    LANG = "fr_FR.UTF-8";
  };
}
