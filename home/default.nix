{ pkgs, config, lib, home-manager, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  #emacs = (import ../darwin/emacs.nix) { pkgs = pkgs; };
in
  {
  # https://nix-community.github.io/home-manager/options.html
  imports = [
    ./k9s
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

    # Aliases for the terminal
    home.shellAliases = {
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs;
      [
	bat
	eza
	fd
	fluxcd
	git
	htop
	jq
	kubectl
	kubelogin
	lf
	mas
	neovim
	oh-my-posh
	ripgrep
	terraform
	tree
	wget
	yq
	zoxide

	# Terminal fonts
	nerd-fonts.hack
	#(nerdfonts.override {fonts = [ "Hack" ]; })

	# markdown lsp requirement
	markdownlint-cli

	# nix lsp requirement
	nixd

	# Terraform lsp, completion
	terraform-ls
	tflint
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
	keymap_mode = "vim-insert";
      };
    };

    # fzf
    programs.fzf = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;

      # https://github.com/Sin-cy/dotfiles/blob/main/zsh/.zshrc
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/fzf.nix
      defaultCommand =  "fd --hidden --strip-cwd-prefix --exclude .git" ;
      defaultOptions = [ "--height 50%" "--layout=default" "--border" "--color=hl:#2dd4bf"];
      # Command that gets executed when pressing ctrl+t
      fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      fileWidgetOptions = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
      # Command that gets executed when pressing ctrl+c
      changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git" ;
      changeDirWidgetOptions = [ "--preview 'eza --icons=always --tree --color=always {} | head -200'" ];
    };

    # Kitty
    programs.kitty = {
      enable = true;

      keybindings = {
	"ctrl+shift+t" = "launch --cwd=current --type=tab";
      };
      settings = {
	active_border_color = "none";
	background_blur = 32;
	background_opacity = "0.93";
	cursor_shape = "beam";
	font_size = 15.5;
	macos_option_as_alt = "yes";
	initial_window_height = 44;
	initial_window_width = 160;
	remember_window_size = "yes";
	titlebar-only = "yes";
	# minimalising the kitty setup look
	draw_minimal_borders = "yes";
	hide_window_decorations = "yes";
	window_border_width = 0;
	# fun with cursor trails
	cursor_trail = 3;
	cursor_trail_decay = "0.1 0.2";
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
    # use our custom theme, but example below of how we could source program 
    # with a default theme
    home.file."/Users/reis.holmes/catppucin.omp.json" = {
      source = ./catppuccin.omp.json;
    };
    programs.oh-my-posh = {
      enable = false;
      
      # useTheme = "catppuccin_macchiato";
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
      defaultKeymap = "viins";
      enableCompletion = false;

      initExtraBeforeCompInit = ''
eval "$(brew shellenv)"
      '';

      initExtra = ''
# mac is dumb
# https://github.com/junegunn/fzf/issues/164#issuecomment-527826925
bindkey "ç" fzf-cd-widget

# for atuin
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh)"

# for az cli
autoload bashcompinit && bashcompinit
source $(brew --prefix)/etc/bash_completion.d/az

# for oh-my-posh
eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/nord.omp.json)"
      '';

      shellAliases = {
	# easier rebuilding on darwin
	nix_rebuild = "darwin-rebuild switch --flake /Users/reis.holmes/Documents/code/repos/nix-darwin/#reis-work";

	# modern cat command remap
	cat="bat";

	# Next level of an ls 
	#options :  --no-filesize --no-time --no-permissions 
	ls="eza --no-filesize --long --color=always --icons=always --no-user";
      };
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
	  "zoxide"
	  #  "z"
	];
      };
    };

  };
}
