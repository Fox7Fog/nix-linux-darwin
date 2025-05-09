# modules/common/programs/kitty.nix
# Kitty terminal configuration

{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  
  # Use unstable kitty on Darwin, regular on Linux
  kittyPackage = if isDarwin then pkgs.unstable.kitty else pkgs.kitty;
in
{
  programs.kitty = {
    enable = true;
    package = kittyPackage;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
    };
  };
}
