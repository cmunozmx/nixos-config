{
  description = "NixOS ThinkPad T495 - deanvlue";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";
    ryoku.url = "github:Ryoku-dev/Ryoku-on-NixOS/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Quickshell Installation
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      hyprland,
      home-manager,
      nix-flatpak,
      ryoku,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.blaxos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          ryoku.nixosModules.default
          { programs.ryoku.enable = true; }
        ];
      };

      # Standalone: apply with `home-manager switch --flake .#deanvlue`
      homeConfigurations.deanvlue = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./deanvlue/home.nix
          nix-flatpak.homeManagerModules.nix-flatpak
        ];
      };
    };
}
