{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  # Boot splash: big NixOS logo instead of the firmware (Lenovo) BGRT logo
  boot.plymouth = {
    enable = true;
    theme = "breeze";
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake-white.png";
  };
  # Start plymouth early at native resolution
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  # Silent boot so text doesn't cover the splash
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  networking.hostName = "blaxos";

  console.useXkbConfig = true;

  # X11 fallback
  services.xserver.xkb.layout = "us";

  # User account
  users.users.deanvlue = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "dialout"
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    claude-code

    # Go
    go
    gopls
    delve
    golangci-lint

    # Node.js (fnm manages versions)
    fnm

    atuin

    # Nix tools
    nixfmt-rfc-style
    nil
    alejandra
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.udev.extraRules = ''
      	SUBSYSTEM=="usb", ATTRS{idVendor}=="2886", MODE="0666"
      	KERNEL=="hidraw", ATTRS{idVendor}=="2886", MODE="0666"
    	SUBSYSTEM=="tty", ATTRS{idVendor}=="2886", MODE="0666"
  '';
  system.stateVersion = "25.11";
}
