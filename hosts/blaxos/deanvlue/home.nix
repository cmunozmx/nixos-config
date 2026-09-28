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
    quickshell
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
}
