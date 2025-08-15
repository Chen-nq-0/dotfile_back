{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  #NIX
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  #Polkit
  security.polkit.enable = true;

  #Environment
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #Programs
  programs = {
    auto-cpufreq.enable = true;
    zsh.enable = true;
    dconf.enable = true;
    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
    };
  };

  #Service
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "weekthly";
      fileSystems = [ "/" ];
    };
    scx.enable = true;
  };

  #Time
  time.timeZone = "Asia/Shanghai";

  #Network
  networking = {
    hostName = "nIX";
    firewall.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
    };
    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  #GRUB And Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto.cachyOverride { mArch = "ZEN4"; };
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "1920x1080";
        configurationLimit = 10;
        theme = "${pkgs.catppuccin-grub.override { flavor = "latte"; }}";
        fontSize = 18;
        extraEntries = ''
          menuentry "windows" {
              search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
              chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  #Locale
  i18n.defaultLocale = "zh_CN.UTF-8";

  #Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-emoji
      maple-mono.NF-CN
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Maple Mono NF CN" ];
        sansSerif = [ "Maple Mono NF CN" ];
        monospace = [ "Maple Mono NF CN" ];
      };
    };
  };

  #User
  users.users.agonie = {
    isNormalUser = true;
    home = "/home/agonie";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  #GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
      obs-vkcapture
    ];
  };
  system.stateVersion = "25.11";

}
