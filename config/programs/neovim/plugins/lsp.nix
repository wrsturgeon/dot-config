ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = {
      installGhc = true;
      ghcPackage = ctx.pkgs.ghc;
    };
    nixd = { };
    ocamllsp.package = ctx.coq.ocamlPackages.ocaml-lsp;
    ruff = { };
    rust_analyzer = {
      installCargo = true;
      cargoPackage = ctx.rust.cargo;
      installRustc = true;
      rustcPackage = ctx.rust.rustc;
    };
  };
  keymaps.lspBuf = {
    "K" = "hover";
  };
}
