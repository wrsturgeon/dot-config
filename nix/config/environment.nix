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
  shellAliases = {
    e = "emacs"; # "${ctx.emacs}/bin/emacs";
  };
  systemPackages =
    (with ctx; [ emacs ])
    ++ (with ctx.pkgs; [
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
      tree
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
