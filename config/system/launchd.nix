ctx:
ctx.linux-mac null (
  let
    with-service-config = builtins.mapAttrs (
      k: v:
      v
      // {
        serviceConfig = {
          KeepAlive = true;
          StandardOutPath = "/var/log/${k}.log";
          StandardErrorPath = "/var/log/${k}.log";
        } // (v.serviceConfig or { });
      }
    );
  in
  {
    daemons = with-service-config {
      custom-system-update = {
        script = ''
          set -eu
          echo
          echo "$(date)"
          echo '================================================================================================================================'
          export USER='autoupdate'
          cd /Users
          for user in $(ls -A); do
            if [ -d /Users/''${user}/.config/nix ]; then
              cd /Users/''${user}/.config/nix
              sudo -i -u "''${user}" /Users/''${user}/.config/nix/rebuild
            fi
          done
        '';
        serviceConfig.StartCalendarInterval = [ { Minute = 0; } ];
      };
    };
    envVariables = {
      LANG = "fr_FR.UTF-8";
    };
  }
)
