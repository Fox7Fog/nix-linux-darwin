# modules/common/programs/bash.nix
# Common Bash settings

{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      # Set the default editor.
      export EDITOR=nvim
    '';
  };
}
