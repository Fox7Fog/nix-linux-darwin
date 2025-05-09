# modules/darwin/packages.nix
# macOS-specific packages

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core utilities from stable channel
    coreutils      # GNU core utilities
    findutils      # GNU find
    gnused         # GNU sed
    wget           # Network downloader
    curl           # Data transfer tool
    
    # Build tools from stable (these are typically stable enough)
    cmake          # Build system
    
    # Applications from unstable channel for latest features and macOS improvements
    unstable.ffmpeg        # Multimedia framework - newer codecs and features
    unstable.yt-dlp        # YouTube downloader - frequent updates for site changes
    unstable.alacritty     # GPU terminal emulator - better macOS integration
    # unstable.kitty is now handled by programs.kitty in modules/common/programs/kitty.nix
    unstable.neovim        # Text editor - newer plugins support
    
    # Other recommended unstable packages for macOS
    unstable.ripgrep       # Fast grep alternative 
    unstable.fd            # Fast find alternative
    unstable.jq            # JSON processor
    
    # KDE/Qt GUI apps (experimental on macOS, may require extra setup or fail to run)
    # Note: Some packages are commented out as they need verification for macOS
    
    # These can be uncommented and prefixed with 'unstable.' once verified:
    # unstable.kate
    # unstable.kdeconnect
    # unstable.kdevelop
    # unstable.konsole
  ];
}
