ctx:
ctx.linux-mac {
  kernelModules = [ "applesmc" ];
  loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot.enable = true;
  };
} null
