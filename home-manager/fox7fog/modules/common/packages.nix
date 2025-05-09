# modules/common/packages.nix
# Common packages for both Linux and macOS

{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Linux-only packages 
    (lib.mkIf isLinux firefox)
    
    # Only install these packages on Linux, as they come from unstable on Darwin
    (lib.mkIf isLinux kitty)
    (lib.mkIf isLinux neovim)
    (lib.mkIf isLinux ripgrep)
    (lib.mkIf isLinux fd)
    
    # Common packages for all platforms
    zoxide
    cowsay
    git
    htop
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
