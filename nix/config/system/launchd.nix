ctx:
let
  with-service-config = builtins.mapAttrs (
    k: v:
    v
    // {
      serviceConfig = (v.serviceConfig or { }) // {
        KeepAlive = true;
        StandardOutPath = "/var/log/${k}.out.log";
        StandardErrorPath = "/var/log/${k}.err.log";
      };
    }
  );
in
{
  agents = with-service-config {
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
