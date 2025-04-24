{
  pkgs,
  config,
  lib,
  home-manager,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  #emacs = (import ../darwin/emacs.nix) { pkgs = pkgs; };
in {
  # https://nix-community.github.io/home-manager/options.html
  imports = [
    ./modules/k9s
    ./modules/fzf.nix
    ./modules/kitty.nix
    ./modules/lazygit.nix
    ./modules/zsh.nix
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
    home.packages = with pkgs; [
      bat
      btop
      duf
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
      tldr
      tree
      wget
      yamllint
      yq

      # Terminal fonts
      nerd-fonts.hack
      #(nerdfonts.override {fonts = [ "Hack" ]; })

      # markdown lsp requirement
      #markdownlint-cli
      # markdown conform requirement
      markdownlint-cli2

      # nix lsp requirement
      alejandra
      nixd

      # Terraform lsp, completion
      terraform-ls
      tflint
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
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

    # oh-my-posh
    # place our custom theme, used in modules/zsh.nix,
    home.file."/Users/reis.holmes/catppuccin.omp.json" = {
      source = ./catppuccin.omp.json;
    };
    # but example below of how we could source program
    # with a default theme
    programs.oh-my-posh = {
      enable = false;
      # useTheme = "catppuccin_macchiato";
    };

    # Wezterm
    programs.wezterm = {
      enable = false;

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

      '';
    };

    # Zoxide
    # https://home-manager-options.extranix.com/?query=programs.zoxide&release=master
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
