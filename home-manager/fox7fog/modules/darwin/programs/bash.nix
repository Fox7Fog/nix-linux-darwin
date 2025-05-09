# modules/darwin/programs/bash.nix
# macOS-specific Bash settings

{ pkgs, ... }:
{
  programs.bash.bashrcExtra = ''
    # macOS uses pbcopy/pbaste natively.
    alias pbcopy='pbcopy'
    alias pbpaste='pbpaste'
  '';
}
