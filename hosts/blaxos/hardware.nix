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
  services.thermald.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  boot.kernelModules = [
    "kvm-amd"
    "amdgpu"
  ];

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
}
