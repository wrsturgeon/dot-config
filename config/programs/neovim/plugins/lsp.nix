ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = { };
    nixd = { };
    ocamllsp.package = ctx.coq.ocamlPackages.ocaml-lsp;
    ruff = { };
    rust_analyzer = { };
  };
  keymaps.lspBuf = {
    "K" = "hover";
  };
}
