# Author: fox7fog
# Date: May 2025
# License: MIT
#
# Description: Main Flake file defining NixOS and Home Manager configurations
#              for cross-platform use (NixOS Linux, macOS Darwin).

{
  description = "Cross-Platform Nix Configuration (NixOS + macOS)";

  # Flake inputs: external dependencies like Nixpkgs and Home Manager.
  inputs = {
    # Pin Nixpkgs stable input to the desired stable branch (24.11).
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Define nixpkgs-unstable input to allow sourcing newer packages via overlays.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      # Use the latest stable Home Manager release compatible with the chosen Nixpkgs.
      # Currently 24.05, adjust if/when a release-24.11 branch becomes available.
      url = "github:nix-community/home-manager/release-24.05"; 
      # Ensure Home Manager internally uses the same nixpkgs revision defined above.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Input definition for nix-darwin, commented out by default.
    # Uncomment if system-level macOS configuration is needed.
    # nix-darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # Flake outputs: definitions for systems and configurations this flake provides.
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      # Define the target system architectures for this configuration.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Generates a list of overlays to apply to nixpkgs.
      # This example adds an 'unstable' attribute pointing to the unstable package set.
      makeOverlays = pkgsUnstable: [
        (final: prev: {
          unstable = import pkgsUnstable {
            system = prev.system;
            # Inherit configuration (like allowUnfree) from the primary nixpkgs set.
            config = prev.config;
          };
        })
        # Additional overlays can be added here.
      ];

      # Generates an evaluated nixpkgs set for a given system architecture.
      # Applies common configuration and overlays.
      makePkgs = system: import nixpkgs {
        inherit system;
        # Common nixpkgs configuration options.
        config = {
          # Permit the installation of packages with non-free licenses.
          allowUnfree = true; 
          # Example: Android SDK license acceptance.
          # android_sdk.accept_license = true;
        };
        # Apply the defined overlays.
        overlays = makeOverlays nixpkgs-unstable;
      };

      # Create an attribute set mapping system architecture strings to their respective nixpkgs instances.
      pkgsFor = nixpkgs.lib.genAttrs supportedSystems makePkgs;

      # Placeholder for potential shared Home Manager module definitions.
      commonHomeModules = [ ]; 

    in {
      # NixOS system configurations (Linux platform only).
      nixosConfigurations = {
        # Configuration entry for the NixOS host named "F7F".
        F7F = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass flake inputs and the specific pkgs set for this system down to modules.
          specialArgs = { inherit inputs pkgsFor; pkgs = pkgsFor."x86_64-linux"; }; 
          modules = [
            # Import the main NixOS system configuration module.
            ./configuration.nix 
            # Import and configure the Home Manager NixOS module.
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true; # Use the top-level pkgs definition.
                useUserPackages = true; # Allow Home Manager to manage user packages.
                # Pass pkgs down again, making it available within Home Manager modules.
                extraSpecialArgs = { inherit inputs pkgsFor; pkgs = pkgsFor."x86_64-linux"; };
                # Define the user managed by Home Manager on this system.
                users.fox7fog = {
                   # Import the user's specific Home Manager configuration.
                   imports = [ ./home-manager/fox7fog/home.nix ];
                };
              };
            }
          ];
        };
      };

      # Home Manager configurations (usable on macOS or non-NixOS Linux).
      homeConfigurations = {
        # Activation target identifier: "username@hostname".
        "fox7fog@F7F" = home-manager.lib.homeManagerConfiguration {
          # Select the appropriate nixpkgs instance for the target macOS system.
          # Adjust architecture (x86_64-darwin or aarch64-darwin) as needed.
          pkgs = pkgsFor."x86_64-darwin"; 
          # Pass arguments, including the correct pkgs set, to the modules.
          extraSpecialArgs = { inherit inputs pkgsFor; pkgs = pkgsFor."x86_64-darwin"; }; 
          modules = [
             # Import the user's Home Manager configuration.
             ./home-manager/fox7fog/home.nix
             # macOS-specific Home Manager modules could be added here.
          ];
        };
      };

      # Placeholder for nix-darwin system configurations.
      # Uncomment and configure if system-level management on macOS is desired.
      # darwinConfigurations = { ... };

    };
} 
