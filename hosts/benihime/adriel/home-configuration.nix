{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    # ../../modules/
  ];

  home = {
    username = "adriel";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      kitty
      discord
      obsidian
      steam
      gimp
      inkscape
    ];
   
    sessionVariables = {
      BROWSER = lib.getExe pkgs.firefox;
      EDITOR = lib.getExe pkgs.vim;
      TERMINAL = lib.getExe pkgs.kitty;
    };
    
    stateVersion = "25.05";
  };

  programs = {
    bash.enable = true;
    firefox.enable = true;

    home-manager.enable = true; 
  };
}
