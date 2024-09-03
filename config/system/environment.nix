ctx: {
  etc = {
    gitignore.text = ''
      **/.DS_Store
    '';
  };
  extraInit = ''
    # echo 'Hello from `extraInit`!'
  '';
  pathsToLink = [ "/share/zsh" ];
  shellAliases = {
    e = "emacs";
    vi = "vim";
    vim = "nvim";
  };
  systemPackages = ctx.dock-apps ++ (with ctx; [ emacs git vim ])
    ++ (with ctx.pkgs; [
      coreutils-full
      fd
      gcc
      gimp
      git-credential-manager
      gnumake
      # minecraft # broken!
      nil
      nixfmt-rfc-style
      ripgrep
      rss2email
      rust-analyzer
      rustfmt
      # steam
      taplo
      # tor-browser
      tree
      zoom-us
    ]) ++ (with ctx.rust; [ cargo rustc ])
    ++ (with ctx.pkgs.coqPackages; [ coq ])
    ++ (ctx.linux-mac [ ctx.pkgs.libsecret ] [ ctx.pkgs.vlc-bin ]);
  variables = let editor = "vi";
  in {
    EDITOR = editor;
    LANG = ctx.pkgs.lib.mkForce "fr_FR.UTF-8";
    KITTY_CONFIG_DIRECTORY = "${ctx.kitty-config}";
    VISUAL = editor;
  };
}
