ctx:
ctx.enable (builtins.listToAttrs (builtins.map (k: {
  name = ctx.pkgs.lib.strings.removeSuffix ".nix" k;
  value = import ./${k} ctx;
}) (builtins.filter (k: k != "default.nix")
  (builtins.filter (ctx.pkgs.lib.strings.hasSuffix ".nix")
    (builtins.attrNames (builtins.readDir ./.))))))
