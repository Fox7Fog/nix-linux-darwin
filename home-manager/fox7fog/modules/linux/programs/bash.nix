# modules/linux/programs/bash.nix
# Linux-specific Bash settings

{ pkgs, ... }:

{
  programs.bash = {
    bashrcExtra = ''
      # On Linux, wl-clipboard provides Wayland equivalents (wl-copy, wl-paste).
      # These should be available in PATH if wl-clipboard is installed via packages.
    '';
  };
}
