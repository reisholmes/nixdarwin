{ pkgs, ... }:

{
  # https://home-manager-options.extranix.com/?query=programs.k9s&release=master
  # https://github.com/catppuccin/k9s
  home.file."/Users/reis.holmes/Library/Application Support/k9s/skins/catpuccin-macchiato.yaml" = {
    source = ./catppuccin-macchiato.yaml;
  };
  home.file."/Users/reis.holmes/Library/Application Support/k9s/views.yaml" = {
    source = ./views.yaml;
  };

  programs.k9s = {
    enable = true;

    settings = {
      k9s = {
	refreshRate = 3;
	ui = {
	  logoless = true;
	  noIcons = false;
	  skin = "catppuccin-macchiato";
	};
      };
    };

    skins = {
      catppucin-macchiato = ./catppuccin-macchiato.yaml;
    };
  };
}
