ctx:
ctx.linux-mac null (
  let
    with-service-config = builtins.mapAttrs (
      k: v:
      v
      // {
        serviceConfig = {
          KeepAlive = true;
          StandardOutPath = "/var/log/${k}.out.log";
          StandardErrorPath = "/var/log/${k}.err.log";
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
          echo '================================'
          set -x
          cd /Users
          for user in $(ls -A); do
            if [ -d /Users/''${user}/.config/nix ]; then
              cd /Users/''${user}/.config/nix
              export USER="''${user}"
              ./rebuild
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
