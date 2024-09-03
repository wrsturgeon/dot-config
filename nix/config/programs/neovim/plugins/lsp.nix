ctx: {
  servers = ctx.enable {
    bashls = { };
    clangd = { };
    hls = { };
    nixd = { };
    ocamllsp = { };
    ruff = { };
    rust-analyzer = {
      installCargo = true;
      cargoPackage = ctx.rust.cargo;
      installRustc = true;
      rustcPackage = ctx.rust.rustc;
    };
  };
  keymaps.lspBuf = { "K" = "hover"; };
}
