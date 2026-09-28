# Config shared by every host. Host-specific configuration.nix files import
# this and layer their own hardware/DE/package differences on top.
{
  pkgs,
  inputs,
  ...
}:
{
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

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 7;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "quiet"
    "splash"
  ];

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";

  networking.networkmanager.enable = true;

  # Display / audio baseline
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;

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

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  users.users.deanvlue = {
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      rofi
      thunar
      swaybg
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services.openssh.enable = true;

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

  # Baseline packages present on every host. Host configuration.nix files
  # append their own extras to environment.systemPackages; NixOS merges the
  # lists rather than overriding.
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    neovim

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

    # Python
    python3
    uv

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
  ];
}
