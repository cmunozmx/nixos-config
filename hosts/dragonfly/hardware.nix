{ pkgs, ... }:

{
  # HP Elite Dragonfly / EliteBook x360 family, SKU 7WK08AV.
  # CPU: Intel Core i5-8265U, 4 cores / 8 threads, VT-x.
  # GPU: Intel UHD Graphics 620, driven by i915.
  # Wireless: Intel Wi-Fi 6 AX200-class adapter, driven by iwlwifi.
  # Audio: Intel Cannon Point-LP HD Audio, driven by SOF/HDA.
  # Input: Synaptics touchpad, Wacom pen/touch, HP WMI hotkeys.
  # Other: Thunderbolt controller, Bluetooth, TPM2, HP HD camera,
  # Realtek USB 10/100/1000 Ethernet, SK hynix NVMe SSD.

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.thermald.enable = true;
  services.fprintd.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  boot.kernelModules = [
    "kvm-intel"
    "i915"
    "iwlwifi"
    "btusb"
    "thunderbolt"
    "r8152"
  ];

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1
  '';
}
