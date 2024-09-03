ctx:
let
  with-service-config = builtins.mapAttrs (
    k: v:
    let
      overwriten = v // {
        serviceConfig = (v.serviceConfig or { }) // {
          KeepAlive = true;
          StandardOutPath = "/var/log/${k}.out.log";
          StandardErrorPath = "/var/log/${k}.err.log";
        };
      };
    in
    builtins.trace (ctx.print { ${k} = overwriten; }) overwriten
  );
in
{
  daemons = with-service-config {
    custom-system-update = {
      script = ''
        for user in $(ls -A /Users); do
          cd /Users/''${user}/.config/nix && ./rebuild
        done
      '';
      serviceConfig.StartCalendarInterval = [ { Minute = 0; } ];
    };
  };
  envVariables = {
    LANG = "fr_FR.UTF-8";
  };
}
