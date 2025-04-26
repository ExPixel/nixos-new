{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
        nixosConfigurations = {
            nixwsl = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ### System
                    nixos-wsl.nixosModules.default
                    {
                        system.stateVersion = "24.11";
                        nix.settings.experimental-features = "nix-command flakes";
                        nix.settings.auto-optimise-store = true;
                        nixpkgs.config.allowUnfree = true;

                        wsl.defaultUser = "marc";
                        wsl.enable = true;
                    }
                    ./system.nix

                    ### Home
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.marc = import ./marc.home.nix;
                    }
                ];
            };
        };
    };
}
