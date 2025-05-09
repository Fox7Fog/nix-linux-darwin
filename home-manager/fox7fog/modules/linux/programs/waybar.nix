# modules/linux/programs/waybar.nix
# Waybar status bar configuration (Linux only)

{ pkgs, lib, isLinux }:

{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = [{ 
      mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = ["hyprland/workspaces" "hyprland/mode"];
          modules-center = ["hyprland/window"];
          modules-right = ["pulseaudio" "network" "cpu" "memory" "clock"];

          "hyprland/workspaces" = {
              format = "{icon}";
              tooltip = false;
          };
          pulseaudio = {
              format = "{volume}% {icon}";
              format-muted = "󰝟 Muted"; # Nerd Font icon for mute.
              format-icons = { default= ["" "" ""]; };
              scroll_step = 5;
              on-click = "pavucontrol";
          };
          network = {
               format-wifi = "{icon} {essid} ({signalStrength}%)";
               format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
               format-ethernet = "󰈀 Eth";
               format-disconnected = "󰤮 Disconnected";
          };
           clock = {
               format = "{:%H:%M %Y-%m-%d}";
               tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
          cpu = {
              format = " {usage}%";
              tooltip = true;
          };
          memory = {
              format = " {used:0.1f}G/{total:0.1f}G";
          };
      };
    }];
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
          font-size: 13px;
          min-height: 0;
      }
      window#waybar {
          background: rgba(30, 30, 46, 0.85);
          color: #cdd6f4;
      }
      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: #bac2de;
          border-bottom: 2px solid transparent;
      }
      #workspaces button.active {
          color: #89b4fa;
          border-bottom-color: #89b4fa;
      }
      #workspaces button.persistent {
          color: #6c7086;
      }
      #workspaces button:hover {
          background: rgba(205, 214, 244, 0.1);
          border-bottom-color: #bac2de;
      }
      #window { font-weight: bold; color: #cba6f7; padding: 0 10px; }
      #pulseaudio, #network, #cpu, #memory, #clock { padding: 0 10px; margin: 0 2px; color: #a6e3a1; }
      #network.disconnected { color: #f38ba8; }
      #pulseaudio.muted { color: #f38ba8; }
    '';
  };
}
