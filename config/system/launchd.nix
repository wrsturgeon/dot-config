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
            # KeepAlive = true;
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
          export NIX_SSHOPTS='-tt'
          for user in $(ls -A); do
            if [ -f /Users/''${user}/.config/nix/rebuild ]; then
              sudo -A -H -i -u "''${user}" bash -x /Users/''${user}/.config/nix/rebuild
            fi
          done
        ''; # For some reason, `nix-collect-garbage` is not recognized in the above
        serviceConfig.StartCalendarInterval = [
          { Minute = 0; }
          { Minute = 15; }
          { Minute = 30; }
          { Minute = 45; }
        ];
      };
    };
    envVariables = ctx.env;
  }
)
