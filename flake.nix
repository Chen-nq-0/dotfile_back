{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      zen-browser,
      chaotic,
      nix-vscode-extensions,
      niri,
      auto-cpufreq,
      catppuccin,
      ...
    }:
    {
      nixosConfigurations = {
        nIX = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            auto-cpufreq.nixosModules.default
            catppuccin.nixosModules.catppuccin
            chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.agonie = ./home.nix;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit
                    inputs
                    niri
                    catppuccin
                    nix-vscode-extensions
                    ;
                  system = "x86_64-linux";
                };
              };
            }
          ];
        };
      };
    };
}
