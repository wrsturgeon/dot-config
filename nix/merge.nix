let
  merge =
    a:
    assert builtins.typeOf a == "set";
    b:
    assert builtins.typeOf b == "set";
    let
      attrs = builtins.attrNames a ++ builtins.attrNames b;
      print-set = set: builtins.foldl' (acc: x: acc + x + " = ...; ") "{ " (builtins.attrNames set) + "}";
      case =
        k:
        assert builtins.typeOf k == "string";
        let
          k-in = builtins.hasAttr k;
        in
        if k-in a then
          if k-in b then merge a.${k} b.${k} else a.${k}
        else if k-in b then
          b.${k}
        else
          abort "Internal error in `merge` on key `${k}` merging `${print-set a}` and `${print-set b}`";
      merge-attr = name: {
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
