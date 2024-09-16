ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = { };
    nixd = { };
    ocamllsp.package = ctx.coq.ocamlPackages.ocaml-lsp;
    ruff = { };
    rust-analyzer = {
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
