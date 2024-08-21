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
      cargoPackage = ctx.pkgs.cargo;
      installRustc = true;
      rustcPackage = ctx.pkgs.rustc;
    };
  };
  keymaps.lspBuf = {
    "K" = "hover";
  };
}
