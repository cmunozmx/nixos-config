{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  # Bootloader
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 7;
  };
  boot.loader.efi.canTouchEfiVariables = true;

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
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  networking.hostName = "blaxos";
  networking.networkmanager.enable = true;

  # Nix settings - enable flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "deanvlue"
    ];
  };

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Hyprland (Wayland compositor)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # Display manager
  services.displayManager.ly.enable = true;

  # X11 fallback
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  # User account
  users.users.deanvlue = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "dialout"
    ];
    packages = with pkgs; [
      tree
      rofi
      thunar
      swaybg
    ];
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    neovim
    claude-code

    # Terminal / Apps
    wezterm
    btop

    # Core build tools
    gcc
    clang
    gnumake
    cmake
    pkg-config
    mold
    binutils

    # Rust
    rustup
    bacon
    cargo-watch
    cargo-edit
    cargo-audit
    rust-analyzer

    # C/C++ libraries often needed by Rust
    openssl
    openssl.dev
    zlib
    sqlite
    sqlite.dev

    # Go
    go
    gopls
    delve
    golangci-lint

    # Python
    python3
    uv

    # Node.js (fnm manages versions)
    fnm

    # Git / networking
    git
    gh
    jq
    yq-go

    # CLI tools
    ripgrep
    fd
    fzf
    eza
    zoxide
    tealdeer
    ugrep
    unzip
    zip
    atuin

    # Nix tools
    nixfmt-rfc-style
    nil
    alejandra
  ];

  # Enable ZSH system-wide
  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nix-ld.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  # OpenSSH
  services.openssh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.hack
    nerd-fonts._0xproto
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Bash aliases (fallback shell)
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

  services.udev.extraRules = ''
      	SUBSYSTEM=="usb", ATTRS{idVendor}=="2886", MODE="0666"
      	KERNEL=="hidraw", ATTRS{idVendor}=="2886", MODE="0666"
    	SUBSYSTEM=="tty", ATTRS{idVendor}=="2886", MODE="0666"
  '';
  system.stateVersion = "25.11";
}
