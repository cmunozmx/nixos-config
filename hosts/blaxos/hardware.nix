{pkgs, ...}: {
  # Lenovo ThinkPad T495
  # CPU: AMD Ryzen (Zen+), with KVM virtualization
  # GPU: AMD Vega (Picasso) integrated graphics
  # Wireless: Intel/Realtek WiFi + Bluetooth
  # Storage: NVMe SSD

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.fwupd.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.corectrl.enable = true;

  environment.systemPackages = [
    pkgs.powertop
    pkgs.brightnessctl
  ];

  # Let the "video" group control the screen and keyboard backlights without
  # sudo (both sysfs nodes are root:root 0644 by default).
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
    SUBSYSTEM=="leds", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
  '';

  boot.kernelModules = [
    "kvm-amd"
    "amdgpu"
  ];

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
}
