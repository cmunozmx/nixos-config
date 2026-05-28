{
  description = "Nix Hyprland Lua, btw.";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    hyprland.url = "githyb:hyprwm/Hyprland/v0.55.0";
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
