ctx:
ctx.enable (
  builtins.listToAttrs (
    builtins.map
      (k: {
        name = ctx.pkgs.lib.strings.removeSuffix ".nix" k;
        value = import "./${k}" ctx;
      })
      (
        builtins.filter (k: k != "default.nix") (
          let
            shit = builtins.filter (ctx.pkgs.lib.strings.hasSuffix ".nix") (
              builtins.attrNames (builtins.readDir ./.)
            );
          in
          builtins.trace (builtins.toString shit) shit
        )
      )
  )
)
