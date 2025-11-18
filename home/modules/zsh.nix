{pkgs, ...}: {
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
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/catppuccin.omp.json)"


      # https://old.reddit.com/r/KittyTerminal/comments/13ephdh/xtermkitty_ssh_woes_i_know_about_the_kitten_but/https://old.reddit.com/r/KittyTerminal/comments/13ephdh/xtermkitty_ssh_woes_i_know_about_the_kitten_but/
      # fixes unknown terminal prompt on SSH sessions
      [[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"

      # Disable zoxide cd override for Claude Code sessions
      if [[ -n "$CLAUDE_CODE_SESSION" ]]; then
        alias cd='builtin cd'
      fi

    '';

    sessionVariables = {
      # claude code
      DISABLE_PROMPT_CACHING = "0";
    };

    shellAliases = {
      # easier rebuilding on darwin
      nix_rebuild = "sudo darwin-rebuild switch --flake /Users/reis.holmes/Documents/code/personal_repos/nix-darwin/#reis-work";

      # modern cat command remap
      cat = "bat";

      # Next level of an ls
      #options :  --no-filesize --no-time --no-permissions
      ls = "eza --no-filesize --long --color=always --icons=always --no-user";

      # list tree
      lt = "lsd --tree";
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
          rev = "25.03.19";
          #this shows how to get a sha256, run the flake build and it will error with the real sha
          #sha256 = pkgs.lib.fakeSha256;
          sha256 = "eb5a5WMQi8arZRZDt4aX1IV+ik6Iee3OxNMCiMnjIx4=";
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
}
