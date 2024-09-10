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
          cd /Users
          for user in $(ls -A); do
            if [ -d /Users/''${user}/.config/nix ]; then
              cd /Users/''${user}/.config/nix
              sudo -i -u "''${user}" bash -c "export USER='autoupdate' && whoami && pwd && source ./rebuild"
            fi
          done
          nix-collect-garbage -j auto --delete-old
        '';
        serviceConfig.StartCalendarInterval = [ { Minute = 0; } ];
      };
    };
    envVariables = {
      LANG = "fr_FR.UTF-8";
    };
  }
)
