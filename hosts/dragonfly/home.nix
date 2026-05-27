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
    supercollider
    tmux-mem-cpu-load
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./.wezterm.lua;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -lah";
      ls = "eza -l";
      g = "git";
    };
    initExtra = ''
      eval "$(fnm env --use-on-cd)"
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "eza -lah";
      ls = "eza -l";
      g = "git";
    };
    history = {
      size = 10000;
      save = 10000;
      share = true;
    };
    initContent = ''
      eval "$(fnm env --use-on-cd)"
      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      palette = "tokyonight";
      format = "$directory$git_branch$git_status$nix_shell$nodejs$rust$python$cmd_duration$line_break$character";

      palettes.tokyonight = {
        blue = "#7aa2f7";
        cyan = "#7dcfff";
        fg = "#c0caf5";
        green = "#9ece6a";
        orange = "#ff9e64";
        purple = "#bb9af7";
        red = "#f7768e";
        yellow = "#e0af68";
      };

      directory = {
        style = "bold blue";
        truncation_length = 3;
      };

      git_branch = {
        style = "purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "red";
        format = "[$all_status$ahead_behind]($style) ";
      };

      nix_shell = {
        style = "cyan";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      nodejs = {
        style = "green";
        format = "[node $version]($style) ";
      };

      rust = {
        style = "orange";
        format = "[rust $version]($style) ";
      };

      python = {
        style = "yellow";
        format = "[py $version]($style) ";
      };

      cmd_duration = {
        style = "fg";
        min_time = 1000;
        format = "[$duration]($style) ";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = ./gitconfig;
    ".tmux.conf".source = ./.tmux.conf;
    ".wezterm.lua".source = ./.wezterm.lua;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.nix",
        callback = function()
          local view = vim.fn.winsaveview()
          vim.cmd("%!nixfmt")
          if vim.v.shell_error ~= 0 then
            vim.cmd("undo")
            vim.notify("nixfmt failed", vim.log.levels.ERROR)
          else
            vim.fn.winrestview(view)
          end
        end,
      })
    '';
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
