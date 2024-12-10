{ pkgs, config, lib, home-manager, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  #emacs = (import ../darwin/emacs.nix) { pkgs = pkgs; };
in
{
  # https://nix-community.github.io/home-manager/options.html
  imports = [
  ];

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs;
      [
	git
        htop
	lf
	jq
        neovim
	ripgrep
	terraform
	tree
	wget
	yq

        # Terminal fonts
	#nerd-fonts.hack
	(nerdfonts.override {fonts = [ "Hack" ]; })
  
	# nix lsp requirement
	nixd
      ];

    home.sessionVariables = {
      EDITOR = "vim";
    };

    # Custom programs that only require a few lines go here

    programs.atuin = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        ctrl_n_shortcuts = false;
        keymap_mode = "vim-normal";
      };
    };

    # Kitty
    programs.kitty = {
      enable = true;

      keybindings = {
        "ctrl+t" = "launch --cwd=current --type=tab";
      };
      settings = {
        active_border_color = "none";
        background_opacity = "0.93";
        draw_minimal_borders = "yes";
        font_size = 12;
	initial_window_height = 44;
	initial_window_width = 160;
	remember_window_size = "yes";
	titlebar-only = "yes";
      };
      themeFile = "Catppuccin-Macchiato";
    };
      
    # LazyGit
    programs.lazygit = {
      enable = true;

      settings = {
      gui.nerdFontsVersion = "3";
      };
    };

    # oh-my-posh
    programs.oh-my-posh = {
      enable = true;
      
      useTheme = "catppuccin_macchiato";
    };

    programs.wezterm = {
      enable = true;
    
      extraConfig = ''
      -- Your lua code / config here
      local wezterm = require 'wezterm';
      return {
           -- Initial sizing of window
           initial_cols = 160,
           initial_rows = 36,
	   font = wezterm.font("Hack Nerd Font"),
	   font_size = 12.0,
	   color_scheme = "Catppuccin Macchiato",
      }
      '';
    };

    # ZSH
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      enableCompletion = false;
      initExtraBeforeCompInit = ''
eval "$(brew shellenv)"
      '';
      initExtra = ''
# for atuin
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh)"

# for az cli
autoload bashcompinit && bashcompinit
source $(brew --prefix)/etc/bash_completion.d/az
      '';
      syntaxHighlighting.enable = true;

      plugins = [
      {
	# will source zsh-autosuggestions.plugin.zsh
	name = "zsh-autosuggestions";
	src = pkgs.fetchFromGitHub {
	  owner = "zsh-users";
	  repo = "zsh-autosuggestions";
	  rev = "v0.7.0";
	  #this shows how to get a sha256, run the flake build and it will error with the real sha
	  #sha256 = pkgs.lib.fakeSha256;
	  sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w="; 
	};
      }
      {
	# will source zsh-autosuggestions.plugin.zsh
	name = "zsh-autocomplete";
	src = pkgs.fetchFromGitHub {
	  owner = "marlonrichert";
	  repo = "zsh-autocomplete";
	  rev = "24.09.04";
	  #this shows how to get a sha256, run the flake build and it will error with the real sha
	  #sha256 = pkgs.lib.fakeSha256;
	  sha256 = "o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w="; 
	};
      }
      ];

      oh-my-zsh = {
	enable = true;

	plugins = [
	  "git"
	  "z"
	];
      };
    };

  };
}
