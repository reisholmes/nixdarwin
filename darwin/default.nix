{ pkgs, config, ... }:

{
  # adds an overlay for karabiner-elements due to issue at:
  # https://github.com/LnL7/nix-darwin/issues/1041
  nixpkgs = {
      config = {
        allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    overlays = [
      (self: super: {
        karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
          version = "14.13.0";

          src = super.fetchurl {
            inherit (old.src) url;
            hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
          };
        });
      })
    ];
  };


  environment.systemPackages = with pkgs; [
    # karabiner-elements
  ];

  homebrew = import ./homebrew.nix // { enable = true; };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  #services.karabiner-elements.enable = true;

  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  #  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # garbage collection
  nix.gc = {
    automatic = true;
    interval = [ {
      Hour = 3;
      Minute = 15;
      Weekday = 7;
    } ];
    options = "--delete-older-than 21d";
  };

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

