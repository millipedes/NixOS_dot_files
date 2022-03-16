{ config, pkgs, ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here.
  # Per-interface useDHCP will be mandatory in the future, so this generated
  # config replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Enable NetworkManager service
  networking.networkmanager.enable = true;

  # Enable udev power service
  services.upower.enable = true;

  # Enable the X11 Windowing System.
  services.xserver.enable = true;
  
  # Optimize the store automatically
  nix.autoOptimiseStore = true;

  # Set i3 as WM
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.knd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  let
    # My R packages
    R-custom = rWrapper.override{
      packages = with rPackages; [
        ggplot2
        pracma
        base64
      ];
    };
  in
  [
     arandr                       # Graphical Interface for xrandr
     asciiquarium                 # A Neat asciiquarium
     blender                      # 3d Python Development GUI
     evince                       # PDF Reader
     feh                          # Image Veiwer
     firefox                      # Web Browser
     fpc                          # Free Pascal Compiler
     git                          # github.com API
     gcc                          # General C Compiler
     ghc                          # General Haskell Compiler
     gdb                          # General C Debugger
     gnumake                      # Makefile
     htop                         # System Resource Monitoring via Terminal
     i3-gaps                      # Window Manager
     i3blocks                     # Bar for Window Manager
     i3lock                       # Lock Screen Application for i3
     imagemagick                  # Image Tool, I use for Blurring
     jdk11                        # Open JDK 11
     kitty                        # Terminal Emulator
     lm_sensors                   # Aids in System Scripts to Get Sevrice info
     lolcat                       # Adds Color to the Inputted Text
     lua                          # Lua Programming Language
     lxappearance                 # Manages Some GTK Interactions (Icons etc.)
     neofetch                     # Display System Info/Logo
     libreoffice                  # Office Suit
     neovim                       # Best Text Editor
     networkmanagerapplet         # Network Manager GUI
     octave                       # Octave
     parted                       # Disk Partitioner
     pamixer                      # Audio Control Stuff
     pavucontrol                  # Audio Control Stuff
     perl                         # Perl Programming Language
     picom                        # Compositor
     python38                     # Python 3.8
     python38Packages.pynvim      # Python Package Required for neovim
     R-custom                     # R With Specified Packages
     rofi                         # Application Launching Menu Tool
     scrot                        # Screen Capturing Tool (Screenshots etc.)
     sl                           # Encourage Precision/Toxicity ;)
     stack                        # Haskell Build Tool
     sysstat                      # System Information
     tesseract                    # OCR Engine
     texlive.combined.scheme-full # All of Latex
     transmission                 # Torrenting Backend
     transmission-gtk             # Torrenting Frontend
     tty-clock                    # Terminal Clock
     unzip                        # Unzip Files
     upower                       # Part of udev Used for Reading Power
     valgrind                     # Memory Management Tool for C
     wget                         # FTP Tool
     xclip                        # Patch for Clipboard Across X Programs
   ];

  # System Fonts
  fonts.fonts = with pkgs; [
    powerline-fonts               # Neovim etc.
    fira-code                     # Most Stuff (kitty, GTK, etc.)
    font-awesome                  # Something on the System
  ];

  services.xserver.videoDrivers = [ "modsetting" ];
  services.xserver.useGlamor = true;

  # TOUCHPAD
  services.xserver.libinput.enable = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
