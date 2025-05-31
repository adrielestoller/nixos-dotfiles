{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  networking = {
    hostName = "benihime";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  time.timeZone = "America/Recife";

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;

      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;

      xkb = {
        layout = "br";
        variant = "";
      };
    };
    
    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  console.keyMap = "br-abnt2";

  security.rtkit.enable = true;

  users.users.adriel = {
    isNormalUser = true;
    description = "Adriel Estoller";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  environment.systemPackages = with pkgs; [
     vim
     git
     github-cli
  ];

  fonts = {
    fontDir.enable = true;
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      roboto
      roboto-mono
      roboto-serif
      freefont_ttf
      jetbrains-mono
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.stateVersion = "25.05"; 
  
  nix = {
    package = pkgs.nixVersions.git;

    settings = {
       auto-optimise-store = true;
       experimental-features = ["nix-command" "flakes"];
       trusted-users = ["@wheel"];
    };
  };

}
