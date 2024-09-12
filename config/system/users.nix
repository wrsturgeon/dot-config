ctx:
let
  user-dir = ctx.linux-mac "/home" "/Users";
  user-cfg = {
    "${ctx.linux-mac "will" "willsturgeon"}" =
      {
        description = "Will Sturgeon";
      }
      // ctx.linux-mac {
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      } { };
  };
  users = builtins.mapAttrs (
    name: v:
    v
    // {
      inherit name;
      createHome = true;
      home = "${user-dir}/${name}";
    }
    // ctx.linux-mac {
      group = "users";
      initialPassword = ""; # there fucking must be a better way
      isNormalUser = true;
    } { }
  ) user-cfg;
in
{
  # mutableUsers = false; # not yet since this might overwrite the root password
  inherit users;
}
// ctx.linux-mac {
  defaultUserShell = ctx.pkgs.zsh;
} { }
