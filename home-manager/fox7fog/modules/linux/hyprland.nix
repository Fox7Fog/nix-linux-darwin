# modules/linux/hyprland.nix
# Hyprland Wayland compositor configuration (Linux only)

{ pkgs, lib, isLinux ? false }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      exec-once = [
        "hyprpaper"
        "waybar"
        "${pkgs.polkit-kde-agent}/bin/polkit-kde-authentication-agent-1" # Start Polkit agent
        "wl-paste --watch cliphist store"
        "swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
      ];
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = { natural_scroll = true; };
        sensitivity = 0;
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(45475aee)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        blur = {
           enabled = true;
           size = 3;
           passes = 2;
        };
        layerrule = [ "blur,waybar" "blur,notifications" ];
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      dwindle = { pseudotile = true; preserve_split = true; };
      master = { new_is_master = true; };
      gestures = { workspace_swipe = true; };
      misc = { force_default_wallpaper = -1; };
      windowrulev2 = [
         "float,class:^(pavucontrol)$"
         "float,class:^(blueman-manager)$"
         "float,title:^(Firefox — Sharing Indicator)$"
      ];
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, E, exec, ${pkgs.kitty}/bin/kitty"
        "$mainMod, D, exec, ${pkgs.wofi}/bin/wofi --show drun" 
        "$mainMod, B, exec, ${pkgs.firefox}/bin/firefox" 
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, F, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:volume 'Volume Up'"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:volume 'Volume Down'"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:volume 'Mute Toggled'"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5% && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:brightness 'Brightness Up'"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%- && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:brightness 'Brightness Down'"
        ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mainMod, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mainMod CTRL, L, exec, ${pkgs.swaylock-effects}/bin/swaylock -f"
      ];
    };
  };
}
