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
    vi = "vim";
    vim = "nvim";
  };
  systemPackages =
    (with ctx; [
      emacs
      vim
    ])
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
    EDITOR = "vi";
    LANG = "fr_FR.UTF-8";
  };
}
