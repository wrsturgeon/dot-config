ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = {
      installGhc = false;
    };
    nixd = {
      installCargo = false;
      installRustc = false;
    };
    ocamllsp.package = ctx.coq.ocamlPackages.ocaml-lsp;
    ruff = { };
    rust_analyzer = { };
  };
  keymaps.lspBuf = {
    "K" = "hover";
  };
}
