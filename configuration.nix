# Author: fox7fog
# Date: May 2024
# License: MIT (or specify otherwise)
#
# Description: NixOS system configuration for the host 'F7F'.
#              Defines system-level settings, services, and hardware configuration imports.

{ config, pkgs, lib, inputs, ... }:

{
  # Import necessary NixOS modules.
  imports =
    [ 
      # Provides hardware-specific settings for this machine.
      # Generated via: `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`
      ./hardware-configuration.nix 
      
      # Optional: Import system-level Hyprland settings (e.g., Pipewire, portals, drivers).
      # ./hyprland.nix
    ];
 
   # Nix package manager settings.
   nix = {
     # Enable Flakes and the modern Nix command-line interface.
     settings.experimental-features = [ "nix-command" "flakes" ];
   };
   
   # System time and localization settings.
   time.timeZone = "America/Sao_Paulo"; 
   i18n.defaultLocale = "en_US.UTF-8";

   # Bootloader configuration (systemd-boot for EFI systems).
   boot.loader = {
     systemd-boot.enable = true;
     efi.canTouchEfiVariables = true; # Necessary for bootloader updates.
   };

   # Network configuration.
   networking = {
     # System hostname. Must match the key used in `flake.nix` -> `nixosConfigurations`.
     hostName = "F7F"; 
     # Enable NetworkManager for managing network devices and connections.
     networkmanager.enable = true; 
     # wireless.enable = true; # Uncomment if Wi-Fi is needed.
   };
   
   # User account definition.
   users.users.fox7fog = {
     isNormalUser = true; # Standard user account.
     description = "F7F"; # User description.
     # Group memberships. `wheel` typically grants sudo privileges.
     extraGroups = [ "networkmanager" "wheel" ]; 
     # Default shell for the user.
     # shell = pkgs.zsh; 
   };
   
   # Sudo configuration.
   security.sudo = {
     # Allow users in the `wheel` group to execute sudo commands without a password.
     # Set to `true` to require password authentication for sudo.
     wheelNeedsPassword = false; 
   };

   # System-wide installed packages.
   # Should be kept minimal; user-specific packages belong in Home Manager.
   environment.systemPackages = with pkgs; [
     wget
     curl
     git
     # A basic text editor available system-wide is useful.
     # vim 
    
     # Example: Installing a package from the unstable channel globally.
     # unstable.some-newer-tool
   ];

   # NixOS state version.
   # Helps manage configuration syntax and behavior changes across releases.
   system.stateVersion = "24.11"; 

   # Graphical display server and login manager configuration.
   services.xserver = {
     enable = true; # Enable the X server, needed for display managers.
     displayManager = {
       # Configure GDM (GNOME Display Manager).
       gdm = {
          enable = true;
          wayland = true; # Enable Wayland support in GDM.
       };
     };
     # Disable the full GNOME Desktop environment.
     desktopManager.gnome.enable = false; 
   };

   # Sound server configuration.
   # Pipewire is generally preferred. Ensure it is enabled, potentially
   # in an imported module like `hyprland.nix`.
   # services.pipewire = { 
   #   enable = true;
   #   alsa.enable = true;
   #   pulse.enable = true;
   # };
   # Enable realtime scheduling capabilities for Pipewire.
   # security.rtkit.enable = true; 

   # Global setting for allowing unfree packages.
   # Note: This is configured globally in `flake.nix` -> `makePkgs` for consistency.
   # nixpkgs.config.allowUnfree = true;

} 