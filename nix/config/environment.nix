ctx: {
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
    (with ctx.pkgs; [
      cargo
      coreutils-full
      discord
      emacs
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
    ++ (with ctx.pkgs.coqPackages; [ coq ])
    ++ (ctx.linux-mac [ ] [ ctx.pkgs.vlc-bin ]);
  variables = {
    EDITOR = "vim";
    LANG = "fr_FR.UTF-8";
  };
}
