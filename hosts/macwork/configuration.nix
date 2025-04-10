{ pkgs, home-manager, ... }:

{
  imports = [
    ../../darwin
  ];

  users.users."reis.holmes" = {
    name = "reis.holmes";
    home = "/Users/reis.holmes";
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}

