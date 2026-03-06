{ config, pkgs, ... }:

{
  xdg.configFile."niri" = {
  source = ./niri;
  recursive = true;
  force = true;
  };

  home.stateVersion = "25.11";

}

