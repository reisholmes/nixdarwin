{
  config,
  pkgs,
  userConfig,
  ...
}: {
  # Ghostty is installed via Homebrew on macOS
  # This module only manages the config file
  home = {
    file = {
      ghosttySettings = {
        source = ./config;
        target =
          if pkgs.stdenv.isDarwin
          then "/Users/${userConfig.name}/.config/ghostty/config"
          else "/home/${userConfig.name}/.config/ghostty/config";
      };
    };
  };
}
