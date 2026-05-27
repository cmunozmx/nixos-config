# NixOS Config

Personal NixOS configuration for the `dragonfly` host.

## Layout

```text
hosts/
  dragonfly/
    configuration.nix           # System configuration
    hardware-configuration.nix  # Generated hardware config for this machine
    home.nix                    # Home Manager configuration for deanvlue
    gitconfig                   # Git config linked into ~/.gitconfig
```

## Host

`dragonfly` is an `x86_64-linux` NixOS system using:

- systemd-boot
- NetworkManager
- Qtile on X11
- Zsh as the user shell
- Home Manager for user dotfiles and shell/editor configuration
- `nixos-unstable` imported through the channel path `<nixos-unstable>` for the latest kernel package set

## Apply System Configuration

From the repository root:

```sh
sudo nixos-rebuild switch -I nixos-config=hosts/dragonfly/configuration.nix
```

The system config expects a `nixos-unstable` channel to be available because `configuration.nix` imports `<nixos-unstable>`.

## Apply Home Manager Configuration

```sh
home-manager switch -f hosts/dragonfly/home.nix
```

Home Manager links files such as `.gitconfig`, `.tmux.conf`, and `.wezterm.lua` from `hosts/dragonfly`.

## Formatting

The Home Manager Neovim configuration formats Nix files with `nixfmt` before save. To format manually:

```sh
nixfmt hosts/dragonfly/*.nix
```
