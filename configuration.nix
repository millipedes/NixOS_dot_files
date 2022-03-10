# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ ###############################
      # PUT YOUR HARDWARE PATH HERE #
      ###############################
      ./hardware-configuration.nix
    ];

  #########################################
  # Double check your bios to make sure   #
  # you are booting off EFI, please see   #
  # NixOS Docs!! This may make other      #
  # systems non-bootable                  #
  # Use the systemd-boot EFI boot loader. #
  #########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
  
  ##############################################################
  # Use the command `$ ip link` and put your wifi device below #
  ##############################################################
  #networking.interfaces.YOURINTERFACEHERE.useDHCP = true;
  networking.networkmanager.enable = true;
  services.upower.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Optimize the store automatically
  nix.autoOptimiseStore = true;

  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  ############################################################################
  # Put your user here, wheel group = super user privledges (i.e. sudo) and  #
  # networkmanager group = allowance to start/stop service with this user    #
  # It would be okay to fill this entry with an already existing user (provided
  # you are okay with that user only being in those groups and is a normal user)
  ############################################################################
  # users.users.YOURUSERHERE = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "networkmanager" ];
  # };


  ##############################################################################
  # Check these packages, I have many that I think the average user may not be #
  # interesed in (i.e. the full latex library                                  #
  ##############################################################################
  environment.systemPackages = with pkgs;
  let
    R-custom = rWrapper.override{
      packages = with rPackages; [
	ggplot2
	pracma
      ];
    };
    in
  [
     wget
     firefox
     kitty
     rofi
     i3blocks
     scrot
     sl
     rPackages.base64
     picom
     networkmanagerapplet
     neofetch
     lolcat
     jdk11
     i3lock
     i3-gaps
     git
     gcc
     ghc
     feh
     htop
     arandr
     xclip
     python38
     python38Packages.pynvim
     neovim
     ##
     # From EOS scrips
     perl
     lm_sensors
     pamixer
     sysstat
     upower
     pavucontrol
     ##
     # Random Stuff, mostly languages
     gnumake
     lxappearance
     valgrind
     gdb
     imagemagick
     lua
     texlive.combined.scheme-full
     evince
     tesseract # okay OCR super easy to use tho
     ##
     # Stuff for kernel project
     #flex
     #bison
     #pahole
     #util-linux
     #pkg-config
     #bc
     #openssl
     #reiserfsprogs
     #squashfs-tools-ng
     #docker
     blender
     transmission
     transmission-gtk
     octave
     ## R Stuff
     R-custom
     #
     unzip
     parted
     # btop # would have installed over htop, but doesn't play nice w/ compositor
     asciiquarium
     tty-clock
   ];

  fonts.fonts = with pkgs; [
    powerline-fonts
    fira-code
    rPackages.fontawesome
  ];

  services.xserver.videoDrivers = [ "modsetting" ];
  services.xserver.useGlamor = true;

  # Touchpad for laptop
  services.xserver.libinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

