{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }: {
        nixosConfigurations = {
            setfive = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ### System
                    ({ nixpkgs, ... }:
                    {
                        system.stateVersion = "24.11";
                        nix.settings.experimental-features = "nix-command flakes";
                        nix.settings.auto-optimise-store = true;
                        nixpkgs.config.allowUnfree = true;
                        nixpkgs.config.permittedInsecurePackages = [
                            "beekeeper-studio-5.2.12"
                        ];
                    })
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
