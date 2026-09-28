# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  unstable = import <nixos-unstable> {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  imports = [
    ../../../modules/common.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  # Use low-latency Zen kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Boot splash
  boot.plymouth.enable = true;

  networking.hostName = "dragonfly"; # Define your hostname.
  # networking.wireless.enable = true; # wireless support with wpa_supplicant

  ## Remote builder
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  console.keyMap = "us";
  # console.useXkbConfig = true; # use xkb.options in tty.

  services.xserver.windowManager.qtile.enable = true;
  services.displayManager.defaultSession = "qtile";

  # Configure keymap in X11
  services.xserver.xkb.layout = "jp";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.deanvlue = {
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "networkManager" # Enable network manager
      "audio"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    uwsm

    llvm
    patchelf

    cargo-deny

    tree

    # Docker
    docker-compose
    podman-compose
    podman
    buildah
    skopeo
    dive # inspect image layers

    # Kubernetes
    kubectl
    k9s
    helm
    kustomize

    # Debugging
    gdb
    lldb
    strace
    ltrace
    tcpdump
    dig
    nmap
    file

    # Virtualization
    qemu_kvm
    virt-manager
    virt-viewer
    libvirt
    spice
    spice-gtk
    spice-vdagent
    swtpm # TPM for Win11 machines
    OVMFFull # UEFI Firmware
    guestfs-tools
    cloud-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.ssh.knownHosts.nix-builder-192-168-100-77 = {
  	hostNames = [ "192.168.100.77" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJ96dKpnfwv+5bw6aPVix4AE4PipjV7VXyr19o4IK7c";
	};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # Optional: allow rootless containers
    containers.enable = true;
  };

  programs.virt-manager.enable = true;
  users.groups = {
    libvirtd.members = ["deanvlue"];
    kvm.members = ["deanvlue"];
  };

  nix.buildMachines = [
    {
      hostName = "192.168.100.77";
      sshUser = "deploy";
      sshKey = "/root/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [];
    }
  ];
}
