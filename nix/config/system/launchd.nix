ctx:
let
  daemons = builtins.mapAttrs (
    k: v:
    v
    // {
      serviceConfig = (if v ? serviceConfig then v.serviceConfig else { }) // {
        StandardOutPath = "/var/log/${k}.out.log";
        StandardErrorPath = "/var/log/${k}.err.log";
      };
    }
  );
in
{
  daemons = daemons {
    custom-system-update = {
      script = ''
        cd ~/.config/nix
        ./rebuild
      '';
    };
  };
  envVariables = {
    LANG = "fr_FR.UTF-8";
  };
}
