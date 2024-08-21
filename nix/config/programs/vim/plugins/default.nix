ctx:
ctx.enable (
  builtins.map (k: import "./${k}" ctx) (
    builtins.filter (k: k != "default.nix") (
      builtins.filter (ctx.pkgs.lib.strings.hasSuffix ".nix") (builtins.attrNames (builtins.readDir ./.))
    )
  )
)
