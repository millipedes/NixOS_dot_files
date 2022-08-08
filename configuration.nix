{ config, pkgs, ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <nixos-hardware/dell/xps/13-9370>
  ];

  ########
  # Boot #
  ########
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  ########
  # Time #
  ########
  time.timeZone = "America/Denver";

  ##############
  # Networking #
  ##############
  # Global useDHCP flag deprecated, explicitly set to false here.
  networking.useDHCP = false;
  # Per-interface useDHCP is mandatory
  networking.interfaces.wlp2s0.useDHCP = true;
  # Enable NetworkManager service
  networking.networkmanager.enable = true;

  ########################
  # Video Acceleratation #
  ########################
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older, but works better with Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

  ############
  # Services #
  ############
  # Enable udev power service
  services.upower.enable = true;
  # Enable the X11 Windowing System.
  services.xserver.enable = true;
  # Video driver stuff
  services.xserver.videoDrivers = [ "modsetting" ];
  services.xserver.useGlamor = true;
  # Enable touchpad
  services.xserver.libinput.enable = true;
  # Set i3 as WM
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  
  #######
  # Nix #
  #######
  # Optimize the store automatically
  nix.autoOptimiseStore = true;

  #########
  # Sound #
  #########
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #########
  # Users #
  #########
  users.users.knd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  ############
  # Packages #
  ############
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
    # I added the unstable channel so now I can get unstable packages
    unstable = import <nixos-unstable> {};
  in
  [
     arandr                       # Graphical Interface for xrandr
     asciiquarium                 # A Neat asciiquarium
     binutils                     # I think this is 32 bit toolchain
     bison                        # Parser Generator
     cargo                        # Rust Build Tool
     evince                       # PDF Reader
     feh                          # Image Veiwer
     firefox                      # Web Browser
     flex                         # Lexical Analyzer Generator
     git                          # github.com API
     gcc                          # General C Compiler
     gdb                          # General C Debugger
     gnumake                      # Makefile
     gnuplot                      # Command Line Plotting Tool
     go                           # Go compiler
     gmsh                         # .stl file reader
     unstable.helix               # Up to date helix, close to switching
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
     man-pages                    # Man pages
     man-pages-posix              # Man pages for like C funcs (i.e. fgets)
     ncurses                      # C library requires shell env on Nix
     unstable.neovim              # Best Text Editor
     networkmanagerapplet         # Network Manager GUI
     ocaml                        # ocaml interpreter
     octave                       # Octave
     openscad                     # For .stl files (3d printing)
     pari                         # Scientific C Library/Extension/Lang
     parted                       # Disk Partitioner
     pamixer                      # Audio Control Stuff
     pavucontrol                  # Audio Control Stuff
     perl                         # Perl Programming Language
     picom                        # Compositor
     plantuml                     # UML maker from scripting language
     python39                     # Python 3.8
     python39Packages.pynvim      # Python Package Required for neovim
     qemu                         # ISO virtualizer
     R-custom                     # R With Specified Packages
     ruby                         # Very Fun Programming Language
     rustc                        # Rust compiler
     rofi                         # Application Launching Menu Tool
     scrot                        # Screen Capturing Tool (Screenshots etc.)
     sl                           # Encourage Precision/Toxicity ;)
     sysstat                      # System Information
     texlive.combined.scheme-full # All of Latex
     tree                         # A utility for visualizing directories
     unzip                        # Unzip Files
     upower                       # Part of udev Used for Reading Power
     valgrind                     # Memory Management Tool for C
     wget                         # FTP Tool
     xclip                        # Patch for Clipboard Across X Programs
     zip                          # Zip tool
     fpc
     doxygen
  ];

  #########
  # Fonts #
  #########
  fonts.fonts = with pkgs; [
    fira-code                     # Most Stuff (kitty, GTK, etc.)
    font-awesome                  # Something on the System
    nerdfonts                     # Gotta Get Em All
    powerline-fonts               # Neovim etc.
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
