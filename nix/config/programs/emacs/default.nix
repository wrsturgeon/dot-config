ctx:
let
  emacs-init = import ./init.el;
  emacs-init-filename = "default.el";
  emacs-init-pkg = ctx.pkgs.runCommand emacs-init-filename { } ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${ctx.pkgs.writeText emacs-init-filename emacs-init} $out/share/emacs/site-lisp/${emacs-init-filename}
  '';
  emacs-pkgs =
    epkgs: with epkgs; [
      evil
      material-theme
      proof-general
    ];
  raw-emacs = ctx.pkgs.emacs-nox; # ctx.pkgs.emacs;
in
(ctx.pkgs.emacsPackagesFor raw-emacs).emacsWithPackages (
  epkgs: [ emacs-init-pkg ] ++ (emacs-pkgs epkgs)
)
