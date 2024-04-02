let
  merge =
    a:
    if builtins.typeOf a != "set" then
      abort "`merge` got a first argument of type `${builtins.typeOf a}` instead of `set`"
    else
      b:
      if builtins.typeOf b != "set" then
        abort "`merge` got a second argument of type `${builtins.typeOf b}` instead of `set`"
      else
        let
          attrs = builtins.attrNames a ++ builtins.attrNames b;
          print-set = set: builtins.foldl' (acc: x: acc + x + " = ...; ") "{ " (builtins.attrNames set) + "}";
          case =
            k:
            if builtins.typeOf k != "string" then
              throw "`case` in `merge.nix` received an argument of type `${builtins.typeOf k}` instead of `string`"
            else
              let
                k-in = builtins.hasAttr k;
              in
              if k-in a then
                if k-in b then merge a.${k} b.${k} else a.${k}
              else if k-in b then
                b.${k}
              else
                abort "Internal error in `merge` on key `${k}` merging `${print-set a}` and `${print-set b}`";
          merge-attr =
            name:
            if builtins.typeOf name != "string" then
              throw "`merge-attr` in `merge.nix` received an argument of type `${builtins.typeOf merge-attr}` instead of `string`"
            else
              {
                inherit name;
                value = case name;
              };
        in
        builtins.listToAttrs (builtins.map merge-attr attrs);
in
assert
  merge { a.b = true; } { a.c = false; } == {
    a = {
      b = true;
      c = false;
    };
  };
merge
