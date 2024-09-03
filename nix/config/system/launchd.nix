ctx:
let
  daemons = builtins.mapAttrs (
    k: v:
    v
    // {
      serviceConfig = (v.serviceConfig or { }) // {
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
      serviceConfig.StartCalendarInterval = [ { Minute = 0; } ];
    };
  };
  envVariables = {
    LANG = "fr_FR.UTF-8";
  };
}
