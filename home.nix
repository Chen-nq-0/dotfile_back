{
  inputs,
  config,
  pkgs,
  lib,
  system,
  catppuccin,
  nix-vscode-extensions,
  ...
}:

let
  mywallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Chen-nq-0/wallpaper_desktop-back/dc110d4925c565f5fc7f514ecb3f3da4bd5829d6/wallhaven-yqmqk7_2560x1600.png";
    hash = "sha256-K62MrRRF0mKF1wnJpoluTA8MSEmHJDNepsff1gFE9k4=";
  };
in

{
  #Modules
  imports = [
    catppuccin.homeModules.catppuccin
    inputs.zen-browser.homeModules.beta
    inputs.niri.homeModules.niri
  ];

  #Catppuccin
  catppuccin = {
    #    enable = true;
    flavor = "latte";
    fuzzel.enable = true;
    helix.enable = true;
    zsh-syntax-highlighting.enable = true;
    vscode.profiles.default = {
      enable = true;
      settings = {
        boldKeywords = true;
        italicComments = true;
        italicKeywords = true;
        colorOverrides = { };
        customUIColors = { };
        workbenchMode = "default";
        bracketMode = "rainbow";
        extraBordersEnabled = false;
      };
    };

    ghostty.enable = true;
    obs.enable = true;
    starship.enable = true;
    cursors = {
      enable = true;
      accent = "light";
    };
  };
  #Home
  home = {
    username = "agonie";
    homeDirectory = "/home/agonie";
    stateVersion = "25.05";
    packages = with pkgs; [
      nix-output-monitor
      nixfmt-rfc-style
      expect
      nixd
      fastfetch
      qq
      wechat
      xwayland-satellite
      zinit
      fd
      wl-clipboard
      cliphist
      wl-clip-persist
      telegram-desktop
      material-design-icons
      brightnessctl
      xsel
      (python3.withPackages (
        python-pkgs: with python-pkgs; [
          pandas
          requests
        ]
      ))
    ];
    #Cursor
    pointerCursor = {
      gtk.enable = true;
      #      package = pkgs.catppuccin-cursors.latteLight;
      #      name = "catppuccin-latte-light-cursors";
      size = 16;
    };
  };

  #GTK
  gtk = {
    enable = true;

    theme = {
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "red" ];
        shade = "light";
        tweaks = [ "frappe" ];
      };
      name = "Catppuccin-GTK-Red-Light-Frappe";
    };

    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "nord" ]; };
      name = "Tela-circle-nord-dark";
    };

    font = {
      name = "Maple Mono NF CN";
      size = 12;
    };
  };

  programs = {

    waybar.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
          ms-python.python
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          intellsmi.comment-translate
          ms-ceintl.vscode-language-pack-zh-hans
        ];
        enableExtensionUpdateCheck = false;
        userSettings = {
          "editor.fontSize" = 16;
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "'Maple Mono NF CN','Material Design Icons',monospace";
          "editor.cursorBlinking" = "smooth";
          "editor.cursorStyle" = "block";
          "gopls" = {
            "ui.semanticTokens" = true;
          };
          "editor.semanticHighlighting.enabled" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            nixd = {
              formatting.command = [ "nixfmt" ];
              options.nixos.expr = ''(builtins.getFlake ... ).nixosConfigurations.nIX.options'';
              options.home-manager.expr = ''(builtins.getFlake ... ).nixosConfigurations.nIX.options.home-manager.users.type.getSubOptions []'';
            };
          };
          "commentTranslate.source" = "Bing";
          "editor.cursorSmoothCaretAnimation" = "on";
        };
      };
    };

    ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        font-family = "Maple Mono NF CN";
      };
    };

    niri = {
      enable = true;
      package = inputs.niri.packages.${system}.niri-unstable;
    };

    zen-browser.enable = true;

    git = {
      enable = true;
    };

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        source ${pkgs.zinit}/share/zinit/zinit.zsh
        autoload -Uz _zinit
        (( ''${+_comps} )) && _comps[zinit]=_zinit
        zinit load zdharma-continuum/history-search-multi-word
        zinit light zsh-users/zsh-autosuggestions
        export https_proxy=http://127.0.0.1:7897 
        export http_proxy=http://127.0.0.1:7897 
        export all_proxy=socks5://127.0.0.1:7897
      '';
      shellAliases = {
        ll = "ls -l";
        edit = "sudo -v";
        update = "sudo -v && sudo unbuffer nixos-rebuild switch --flake ~/.my-nIX/.#nIX --log-format internal-json -v |& nom --json";
      };

      history.size = 10000;
      history.path = "$HOME/.zsh_history";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          true-color = true;
        };
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        editor.indent-guides = {
          render = true;
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
            language-servers = [ "nixd" ];
          }
        ];
        language-server.nixd = {
          command = "nixd";
        };
      };
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Maple Mono NF CN:size=15";
          icon-theme = "Tela-circle-nord-dark";
        };
      };
    };

    home-manager.enable = true;
  };

  services = {

    wpaperd = {
      enable = true;
      settings = {
        eDP-1 = {
          path = mywallpaper;
        };
      };
    };
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
      fcitx5-tokyonight
    ];
  };

}
