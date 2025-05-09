# modules/linux/packages.nix
# Linux-specific packages

{ pkgs, ... }:

{
  home.packages = with pkgs; [
     waybar
     wofi
     swaylock-effects
     swayidle
     hyprpaper
     wl-clipboard
     cliphist
     grim
     slurp
     pavucontrol
     brightnessctl
     polkit-kde-agent
  ];
}
