ctx:
let
  user-dir = ctx.linux-mac "/home" "/Users";
  user-cfg = {
    "${ctx.linux-mac "will" "willsturgeon"}" = {
      createHome = true;
      description = "Will Sturgeon";
      extraGroups = [
        "wheel"
      ];
      group = "users";
    };
  };
in
{
  mutableUsers = false;
  users = builtins.mapAttrs (
    name: v:
    v
    // {
      inherit name;
      home = "${user-dir}/${name}";
      isNormalUser = true;
    }
  ) user-cfg;
}
