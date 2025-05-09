# modules/linux/sessionVariables.nix
# Linux-specific user session environment variables

{
  home.sessionVariables = { 
     # Hint for Electron-based applications to use Wayland.
     NIXOS_OZONE_WL = "1";
     # Workaround for cursor rendering issues on some Wayland setups.
     WLR_NO_HARDWARE_CURSORS = "1";
  };
}
