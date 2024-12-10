{ pkgs, home-manager, ... }:

{
  imports = [
    ../../darwin
  ];

  users.users."reis.holmes" = {
    name = "reis.holmes";
    home = "/Users/reis.holmes";
  };

  security.pam.enableSudoTouchIdAuth = true;
}

