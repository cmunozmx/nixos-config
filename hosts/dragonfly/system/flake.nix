{
  description = "Nix Hyprland Lua, btw.";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";

    home-manager = {
    	url = "github:nix-community/home-manager/release-26.05";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    ...
  }: {
    nixosConfigurations.dragonfly = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
