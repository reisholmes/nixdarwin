{
  #https://mynixos.com/nix-darwin/options/homebrew

  # uninstall or zap, zap may remove files other programs require
  onActivation.cleanup = "uninstall";

  # directory (and usually git repo) of formulae, casks, and/or external cmds
  taps = [
    "hashicorp/tap"
    "powershell/tap"
  ];

  # typically pre compiled binaries
  brews = [
    "azure-cli"
    "terraform"
  ];

  # Homebrew package definition that installs macOS native applications
  # Casks offer a way to cmd line manage installs of Graphical apps
  casks = [
    "powershell"
    # raycast shortcut setup
    # https://www.youtube.com/watch?v=DBifQv9AYhc
    "raycast"
  ];

  # MacStore apps, have to be logged in
  masApps = {
  };
}
