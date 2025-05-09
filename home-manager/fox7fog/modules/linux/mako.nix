# modules/linux/mako.nix
# Mako notification daemon configuration (Linux only)

{ lib, isLinux }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    borderSize = 2;
    borderRadius = 5;
    padding = "5,10";
    layer = "overlay";
    anchor = "top-right";
    backgroundColor = "#1e1e2ecc"; 
    borderColor = "#cba6f7aa"; 
    textColor = "#cdd6f4"; 
  };
}
