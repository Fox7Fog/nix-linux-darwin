# Author: fox7fog
# Date: May 2025
# License: MIT
#
# Description: Top-level Home Manager configuration for user 'fox7fog'.
#              Imports common and platform-specific modules (Linux/Darwin).
#              Manages user environment, packages, dotfiles, and services.

{ config, pkgs, lib, ... }:

let
  # Detect the current target platform.
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  # Define lists of modules to import based on platform.
  # Common modules are always imported.
  commonModules = [
    ./modules/common/packages.nix
    ./modules/common/programs/git.nix
    ./modules/common/programs/kitty.nix
    ./modules/common/programs/bash.nix
    ./modules/common/sessionVariables.nix
  ];

  # Linux (NixOS) specific modules.
  linuxModules = [
    ./modules/linux/packages.nix
    ./modules/linux/programs/bash.nix
    ./modules/linux/programs/waybar.nix
    ./modules/linux/hyprland.nix
    ./modules/linux/mako.nix
    ./modules/linux/sessionVariables.nix
  ];

  # macOS (Darwin) specific modules.
  darwinModules = [
    ./modules/darwin/packages.nix
    ./modules/darwin/programs/bash.nix
    # Add future macOS-specific modules here, e.g.:
    # ./modules/darwin/sessionVariables.nix
  ];
in
{
  # Import modules: always include common, add platform-specific ones conditionally.
  imports = commonModules
    ++ lib.optionals isLinux linuxModules
    ++ lib.optionals isDarwin darwinModules;

  # User identity and Home Manager configuration
  home.username = "fox7fog";
  home.homeDirectory = "/Users/fox7fog";

  # Set the Home Manager state version.
  # This is required and helps manage configuration format changes across releases.
  home.stateVersion = "24.05";

  # Enable Home Manager's management features.
  # This needs to be declared directly in the top-level configuration.
  programs.home-manager.enable = true;
  
  # Disable warning about version mismatch between Home Manager and Nixpkgs
  home.enableNixpkgsReleaseCheck = false;

  # Note: All specific package installations, program configurations,
  # service definitions, and environment variables are defined within
  # the imported modules located in the ./modules directory.

  # --- macOS Specific Settings ---
  
  # Create symlinks for GUI applications to make them visible in Finder and Launchpad
  home.activation = lib.mkIf isDarwin {
    copyApplications = lib.mkAfter ''
      echo "Creating ~/Applications/NixApps directory..."
      mkdir -p ~/Applications/NixApps
      
      echo "Linking Nix-installed applications..."
      for app in $(find ~/.nix-profile/Applications -type d -name "*.app" -depth 1 2>/dev/null); do
        appname=$(basename "$app")
        echo "Linking $appname"
        ln -sf "$app" ~/Applications/NixApps/
      done
      
      # Refresh Finder to detect new symlinks
      if command -v osascript &>/dev/null; then
        echo "Refreshing Finder..."
        osascript -e 'tell application "Finder" to quit'
        osascript -e 'delay 0.5'
        osascript -e 'tell application "Finder" to activate'
      fi
    '';
  };
  
  # Other macOS specific settings
  # If using the nix-darwin system module, top-level macOS settings
  # specific to nix-darwin (not Home Manager) might go here.
  # system.defaults = lib.mkIf isDarwin { ... };
  # home.casks = lib.mkIf isDarwin { ... }; # Example: Homebrew casks via nix-darwin

}
