ctx:
let
  user-dir = ctx.linux-mac "/home" "/Users";
  user-cfg = {
    "${ctx.linux-mac "will" "willsturgeon"}" = {
      description = "Will Sturgeon";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
  users = builtins.mapAttrs (
    name: v:
    v
    // {
      inherit name;
      createHome = true;
      group = "users";
      home = "${user-dir}/${name}";
      isNormalUser = true;
      initialPassword = ""; # there fucking must be a better way
    }
  ) user-cfg;
in
{
  # mutableUsers = false; # not yet since this might overwrite the root password
  inherit users;
}
