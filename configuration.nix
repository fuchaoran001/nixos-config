{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.etc."nixos-flake".source = "/home/f/nixos-config";
  

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  services.dbus.enable = true;

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        #qt6Packages.fcitx5-chinese-addons 
        fcitx5-gtk # GTK程序支持
        (fcitx5-rime.override {
        rimeDataPkgs = with pkgs; [ rime-ice ]; 
      })
      ];
    };
    
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  #当没有桌面管理器时，是否运行 XDG 自动启动项
  services.xserver.desktopManager.runXdgAutostartIfNone = true; 

  programs.git = {
        enable = true;
        config ={
                user.name = "fcr";
                user.email = "fuchaoran001@gmail.com";
        };
  };



  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;
  


 services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
          --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions \
          --remember-session \
          --remember \
          --time \
          --asterisks \          
          --exclude-desktops gnome.desktop 
          --power-menu "shutdown,reboot"
      '';
      user = "greeter";  #用低权限用户 greeter 运行登录界面（安全考虑）
    };
  };
};

  ###gnome
  services.displayManager.gdm.enable = false; #如果用其他显示管理器必须设为false
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  
  ###cosmic
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false; #如果用其他显示管理器必须设为false
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-files cosmic-edit cosmic-term      
    cosmic-store cosmic-player  cosmic-reader
  ];
  programs.niri.enable = true;
  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #  PipeWire 音频系统的配置
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.f = {
    isNormalUser = true;
    description = "f";
    extraGroups = [ 
	"networkmanager" # 允许用户管理网络连接
	"wheel" # 允许用户使用 sudo
    ];
    # 为用户预装的软件包
    packages = with pkgs; [
    
    ];
  };
  




  
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.v2raya.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   alacritty
   git
   google-chrome
   gnomeExtensions.kimpanel 
   tofi
  ];

 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; #永远不需要修改

}
