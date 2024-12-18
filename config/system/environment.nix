ctx: {
  etc = {
    gitignore.text = ''
      **/.DS_Store
    '';
  };
  extraInit = ''
    # echo 'Hello from `extraInit`!'
  '';
  # pathsToLink = [ "/share/zsh" ];
  shellAliases = {
    e = "emacs";
    vi = "vim";
    vim = "nvim";
  };
  systemPackages =
    ctx.dock-apps
    ++ (with ctx; [
      coq
      emacs
      git
      (hammer.lib.with-pkgs pkgs coq-pkgs).whole-enchilada
      rebuild
      rust
      vim
    ])
    ++ (with ctx.pkgs; [
      coreutils-full
      fd
      gcc
      gimp
      # git-credential-manager
      git-credential-oauth
      gnumake
      # minecraft # broken!
      nil
      nixfmt-rfc-style
      ripgrep
      rss2email
      rust-analyzer
      # steam
      taplo
      # tor-browser
      tree
      zoom-us
    ])
    ++ (
      with ctx.pkgs;
      ctx.linux-mac
        [
          libsecret
          pantheon-tweaks
        ]
        [ vlc-bin ]
    );
  variables = ctx.env;
}
