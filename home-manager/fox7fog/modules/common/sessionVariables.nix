# modules/common/sessionVariables.nix
# Common user session environment variables

{ pkgs, ... }: {
  home.sessionVariables = {
     EDITOR = "nvim";
  };
}
