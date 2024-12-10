{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  # homebrew = import ./homebrew.nix // { enable = true; };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.karabiner-elements.enable = true;

  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";


  system.defaults.CustomUserPreferences = {
    # "com.google.Chrome" = {
    #     "NSUserKeyEquivalents" = {
    #         "Open Location..." = "@d";
    #     };
    # };
  };

  #services.skhd.enable = true;
  # system.keyboard.userKeyMapping = [
  #     # caps lock to escape
  #     {
  #         HIDKeyboardModifierMappingSrc = 30064771129; 
  #         HIDKeyboardModifierMappingDst = 30064771113;
  #     }
  #     # 
  # ]
}

