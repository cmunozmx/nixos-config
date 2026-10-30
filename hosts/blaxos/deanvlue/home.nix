{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deanvlue";
  home.homeDirectory = "/home/deanvlue";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    fnm
    hack-font
    terminus_font
    noto-fonts
    noto-fonts-color-emoji
    nixfmt-rfc-style
    virt-viewer
    tmux
    (symlinkJoin {
      name = "supercollider-pipewire-jack";
      paths = [ supercollider ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/scide \
          --set QT_QPA_PLATFORM xcb \
          --prefix LD_LIBRARY_PATH : ${pipewire.jack}/lib
        wrapProgram $out/bin/scsynth \
          --prefix LD_LIBRARY_PATH : ${pipewire.jack}/lib
        wrapProgram $out/bin/supernova \
          --prefix LD_LIBRARY_PATH : ${pipewire.jack}/lib
      '';
    })
    pipewire.jack
    tmux-mem-cpu-load
    feh
    nil
    alejandra
    lua-language-server
    ffmpeg
    foot
    btop
    quickshell
    neovim
    wezterm
    starship
    chezmoi
    qt6.qtdeclarative # provides qmlls
    zed-editor
    tailscale
    hyprpaper
    hyprlock
    atuin
  ];

  # Dotfiles (shell rc, git, tmux, wezterm, hyprland, nvim, starship) are managed
  # by chezmoi (~/.local/share/chezmoi), not home-manager. This block only
  # installs packages and handles session-level/system-integration settings
  # (GTK theme, dconf, env vars) that aren't really "dotfiles".

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deanvlue/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_THEME = "Adwaita:dark";
  };

  home.sessionPath = [ "/home/deanvlue/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.flatpak = {
    enable = true;
    packages = [
      # "com.spotify.Client"
      "io.github.getnf.embellish"
      "io.github.nokse22.minitext"
      "com.collaboraoffice.Office"
      "dev.zed.Zed"
      "app.drey.Warp"
      "app.getclipboard.Clipboard"
      "ar.com.tuxguitar.TuxGuitar"
      "cc.arduino.IDE2"
      "com.belmoussaoui.Obfuscate"
      "com.blockstream.Green"
      "com.calibre_ebook.calibre"
      "com.exok.Celeste64"
      "com.github.finefindus.eyedropper"
      "com.github.hluk.copyq"
      "com.github.reduz.ChibiTracker"
      "com.github.tchx84.Flatseal"
      "com.saivert.pwvucontrol"
      "com.usebottles.bottles"
      "com.valvesoftware.Steam"
      "info.puredata.Pd-extended"
      "io.github.dimtpap.coppwr"
      "io.github.dvlv.boxbuddyrs"
      "io.github.ellie_commons.sequeler"
      "io.github.flattool.Ignition"
      "io.github.flattool.Warehouse"
      "io.github.kolunmi.Bazaar"
      "io.github.ungoogled_software.ungoogled_chromium"
      "io.podman_desktop.PodmanDesktop"
      "org.audacityteam.Audacity"
      "org.gimp.GIMP"
      "org.gnome.Calculator"
      "org.gnome.Calendar"
      "org.gnome.Characters"
      "org.gnome.clocks"
      "org.gnome.Connections"
      "org.gnome.Contacts"
      "org.gnome.DejaDup"
      "org.gnome.FileRoller"
      "org.gnome.font-viewer"
      "org.gnome.Fractal"
      "org.gnome.Logs"
      "org.gnome.Loupe"
      "org.gnome.Maps"
      "org.gnome.NautilusPreviewer"
      "org.gnome.Papers"
      "org.gnome.Podcasts"
      "org.gnome.Snapshot"
      "org.gnome.TextEditor"
      "org.gnome.Weather"
      "org.inkscape.Inkscape"
      "org.jacktrip.JackTrip"
      "org.qbittorrent.qBittorrent"
      "org.raspberrypi.rpi-imager"
      "org.sqlitebrowser.sqlitebrowser"
      "org.videolan.VLC"
    ];
    uninstallUnmanaged = true; # remove any flatpak not listed here
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;

    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    font = {
      name = "Sans";
      size = 12;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "adwaita-dark";

    qt5ctSettings.Fonts = {
      fixed = ''"Sans,12"'';
      general = ''"Sans,12"'';
    };
    qt6ctSettings.Fonts = {
      fixed = ''"Sans,12"'';
      general = ''"Sans,12"'';
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "font.size.variable.x-western" = 12;
        "font.size.monospace.x-western" = 12;
        "font.minimum-size.variable.x-western" = 12;
        "layout.css.prefers-color-scheme.content-override" = 0;
      };
    };
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
