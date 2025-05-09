# config/programs/git.nix
# Git configuration

{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "fox7fog";
    userEmail = "fox7fog@protonmail.com";
    # Further git settings (aliases, etc.) can be added here.
  };
}
