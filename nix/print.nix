pkgs:
let
  print =
    x:
    if builtins.isAttrs x then
      "{ ${pkgs.lib.strings.concatStringsSep "; " (builtins.mapAttrs (k: v: "${k} = ${print v}") x)} }"
    else
      (builtins.toString x);
in
print
