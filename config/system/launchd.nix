ctx:
ctx.linux-mac null (
  let
    with-service-config = builtins.mapAttrs (
      k: v:
      v
      // {
        serviceConfig =
          let
            log-path = "/var/log/${k}.log";
          in
          {
            KeepAlive = true;
            StandardOutPath = log-path;
            StandardErrorPath = log-path;
          }
          // (v.serviceConfig or { });
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
              sudo -i -u "''${user}" bash -eux /Users/''${user}/.config/nix/rebuild
            fi
          done
          sudo nix-collect-garbage -j auto --delete-old
          nix-collect-garbage -j auto --delete-old
        '';
        serviceConfig.StartCalendarInterval = [ { Minute = 0; } ];
      };
    };
    envVariables = ctx.env;
  }
)
