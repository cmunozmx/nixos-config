# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let 
	unstable = import <nixos-unstable> {
		system = "x86_64-linux";
		config.allowUnfree = true;
	};	
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # Use stable kernel in unstable nixos branch - cm
  boot.kernelPackages = unstable.linuxPackages_latest;

  networking.hostName = "dragonfly"; # Define your hostname.
  # networking.wireless.enable = true; # wireless support with wpa_supplicant

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  ## Remote builder
  nix.distributedBuilds = true;

  nix.settings = {
  	builders-use-substitutes = true;
	experimental-features = [ "nix-command" "flakes" ];
	trusted-users = ["root" "deanvlue"];
  };

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver = {
    windowManager.qtile.enable = true;
    
  };
  services.displayManager.defaultSession = "qtile";
 

  # Configure keymap in X11
  services.xserver.xkb.layout = "jp";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  services.libinput = {
    enable = true;

    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.deanvlue= {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"             # Enable ‘sudo’ for the user.
      "networkManager"    # Enable network manager
    ];     packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   curl
   neovim


    # Apps
    wezterm
    btop

   # Core build tools
   gcc
   clang
   llvm
   gnumake
   cmake
   pkg-config
   mold # fast linker
   binutils
   patchelf

   # Rust
   rustup
   bacon
   cargo-watch
   cargo-edit
   cargo-audit
   cargo-deny
   rust-analyzer
   
   # C/C++ libraries often needed by Rust
   openssl
   openssl.dev
   zlib
   sqlite
   sqlite.dev

   # Python
   python3
   uv # python package manager

   # Git / networking
   git
   gh
   curl
   wget
   jq
   yq-go

   # CLI Tooling
   ripgrep
   fd
   fzf
   eza
   zoxide
   tealdeer
   ugrep
   tree
   unzip
   zip
   
   # Docker
   docker-compose
   podman-compose
   podman
   buildah
   skopeo
   dive           # inspect image layers

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
    swtpm         # TPM for Win11 machines
    OVMFFull      # UEFI Firmware
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
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
  
  programs.nix-ld.enable = true;

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
   noto-fonts
   noto-fonts-color-emoji
   nerd-fonts.hack
   nerd-fonts._0xproto
   nerd-fonts.jetbrains-mono
   nerd-fonts.symbols-only
  ];

  programs.bash = {
    shellAliases = {
      ll = "eza -lah";
      ls = "eza -lh";
    };
     interactiveShellInit = ''
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
      '';
  };

    nix.buildMachines = [
      {
        hostName = "192.168.100.77";
        sshUser = "deploy";
        sshKey = "/root/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
    ];

# Enable ZSH

programs.zsh.enable = true;

security.rtkit.enable = true;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };



}
