{
  onActivation.cleanup = "uninstall";

  # directory (and usually git repo) of formulae, casks, and/or external cmds
  taps = [
    "hashicorp/tap"
  ];

  # typically pre compiled binaries
  brews = [
    "azure-cli"
    "terraform"
  ];

  # Homebrew package definition that installs macOS native applications
  # Casks offer a way to cmd line manage installs of Graphical apps
  casks = [
    "raycast"
  ];

  # MacStore apps, have to be logged in
  masApps = {
  };
}
