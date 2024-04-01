let
  merge =
    a: b:
    let
      attrs = builtins.attrNames a ++ builtins.attrNames b;
      case =
        name:
        if a ? name then
          if b ? name then merge a.name b.name else a.name
        else if b ? name then
          b.name
        else
          abort "Internal error in `merge` on key `${name}`";
      merge-attr = name: {
        inherit name;
        value = case name;
      };
    in
    assert
      (merge { a.b = true; } { a.c = false; }) == {
        a = {
          b = true;
          c = false;
        };
      };
    builtins.listToAttrs (builtins.map merge-attr attrs);
in
merge
