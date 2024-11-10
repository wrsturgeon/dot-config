ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = {
      installGhc = false;
    };
    nixd = { };
    ocamllsp.package = ctx.coq.ocamlPackages.ocaml-lsp;
    ruff = { };
    rust_analyzer = {
      installCargo = false;
      installRustc = false;
    };
  };
  keymaps.lspBuf = {
    "K" = "hover";
  };
}
