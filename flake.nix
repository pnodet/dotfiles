{
  description = "macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    nix-casks = {
      url = "github:atahanyorganci/nix-casks/archive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-casks,
      home-manager,
      nix-homebrew,
      homebrew-aerospace,
      homebrew-core,
      homebrew-cask,
    }:
    let
      user = {
        name = "pnodet";
        fullName = "Paul Nodet";
      };

      machines = {
        "${user.name}-mbp-m4" = {};
        "${user.name}-mbp-m1" = {};
      };

      configuration =
        { pkgs, ... }:
        {
          nix.settings = {
            experimental-features = "nix-command flakes";
            substituters = [
              "https://cache.nixos.org"
              "https://nix-community.cachix.org"
            ];
            trusted-users = [
              user.name
              "@admin"
            ];
          };

          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
          };

          programs.zsh.enable = true;

          environment = {
            variables = {
              EDITOR = "nvim";
              VISUAL = "nvim";
            };

            shells = with pkgs; [ zsh ];

            systemPackages = with pkgs; [
              vim # Fallback editor
              findutils # Collection of GNU find, xargs, and locate
              gnugrep # GNU grep, print lines matching a pattern
              gnused # GNU sed, stream editor for filtering and transforming text
              gawk # GNU awk, pattern scanning and processing language
              rsync # Fast, versatile, remote (and local) file-copying tool
              which # Shows the full path of shell commands
              file # Determine file type
              less # Terminal pager program
              coreutils # GNU core utilities
              pciutils # Utilities for inspecting and manipulating PCI devices
              dnsutils # DNS lookup utilities (dig, nslookup, etc.)
            ];
          };

          fonts = {
            packages = with pkgs; [
              # nerdfonts
              # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
              nerd-fonts.symbols-only # symbols icon only
              nerd-fonts.fira-code
              nerd-fonts.jetbrains-mono
              nerd-fonts.iosevka
              nerd-fonts.monaspace
              nerd-fonts.commit-mono
            ];
          };

          homebrew = {
            enable = true;
            brews = [
              "mas" # Mac App Store command line interface
              "curl" # URL transfer tool (macOS-optimized version)
              "cocoapods" # Dependency manager for Swift and Objective-C projects
              "scw" # Scaleway CLI
              "turso" # Turso database CLI
            ];

            masApps = {
              "Refined GitHub" = 1519867270;
              "Klack" = 6446206067;
              "Xcode" = 497799835;
              # "Microsoft Excel"       = 462058435;
              # "Microsoft PowerPoint"  = 462062816;
              # "Microsoft Word"        = 462054704;
            };

            casks = [
              "nikitabobko/tap/aerospace" # Tiling window manager for macOS

              "cap" # Screen recording software
              "macfuse" # File system integration
              "messenger" # Facebook Messenger desktop app
              "steam" # Digital distribution platform for games
              "tailscale-app" # Zero config VPN
              "transmission" # BitTorrent client
              "ungoogled-chromium" # Google Chromium, sans integration with Google
              "zoom" # Video conferencing
            ];

            onActivation = {
              autoUpdate = false;
              cleanup = "zap";
            };
          };

          networking = {
            knownNetworkServices = [
              "Ethernet"
              "Wi-Fi"
              "Tailscale"
            ];
            dns = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          };

          security.pam.services.sudo_local.touchIdAuth = true;

          system = {
            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 6;
            primaryUser = user.name;
            configurationRevision = self.rev or self.dirtyRev or null;

            startup.chime = false;
          };
        };

    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#pnodet-mbp-m4
      # $ darwin-rebuild build --flake .#pnodet-mbp-m1
      darwinConfigurations = builtins.mapAttrs (hostname: machineConfig: nix-darwin.lib.darwinSystem {
        # From https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-2412587886
        modules = [
          (
            { config, ... }:
            {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            }
          )
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix.enable = false;

            system = {
              primaryUser = user.name;
            };

            users.users.${user.name} = {
              home = "/Users/${user.name}";
              name = user.name;
            };

            nix-homebrew = {
              user = user.name;
              enable = true;
              enableRosetta = true;
              mutableTaps = false;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "nikitabobko/homebrew-tap" = homebrew-aerospace;
              };
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              verbose = true;
              users.${user.name} =
                { pkgs, ... }:
                {
                  home = {
                    username = user.name;
                    homeDirectory = "/Users/${user.name}";
                    stateVersion = "25.05";

                    packages =
                      (with pkgs; [
                        nil # Nix language server
                        nixd # Nix language server (alternative)
                        lazygit # Simple terminal UI for git commands
                        gh # GitHub CLI
                        delta # Syntax-highlighting pager for git and diff
                        cloudflared # Cloudflare tunnel
                        git-lfs # Git Large File Storage

                        go # Go programming language
                        rustup # Rust toolchain installer
                        deno # Secure runtime for JavaScript and TypeScript
                        bun # Fast all-in-one JavaScript runtime
                        fnm # Fast Node.js version manager
                        uv # Ultra-fast Python package installer
                        pipx # Install and run Python applications in isolated environments
                        ruby # Ruby programming language
                        php # PHP programming language
                        zig # General-purpose programming language

                        cmake # Cross-platform build system
                        ninja # Small build system with a focus on speed
                        just # Command runner and build tool
                        meson # Open source build system
                        autoconf # Generate configuration scripts
                        automake # Tool for automatically generating Makefile.in files
                        ccache # Compiler cache for faster rebuilds
                        nasm # Netwide Assembler
                        act # Run GitHub Actions locally
                        gofumpt # Stricter gofmt
                        swiftformat # Code formatter for Swift

                        eza # Modern replacement for ls
                        bat # Better cat with syntax highlighting
                        bottom # Cross-platform graphical process/system monitor
                        broot # Interactive tree view, fuzzy search, and directory navigation
                        dust # More intuitive version of du
                        duf # Disk Usage/Free Utility
                        fd # Simple, fast alternative to find
                        procs # Modern replacement for ps
                        ripgrep # Line-oriented search tool
                        sd # Intuitive find & replace CLI
                        xh # Friendly and fast tool for sending HTTP requests
                        tree # Display directories as trees
                        zoxide # Smarter cd command
                        hyperfine # Command-line benchmarking tool
                        tealdeer # Fast tldr client
                        duti # Select default apps for documents and URL schemes on macOS

                        htop # Interactive process viewer
                        lsof # List open files
                        wget # Network downloader
                        jq # Command-line JSON processor
                        yq # Command-line YAML processor

                        rar # Archive manager for RAR files
                        unzip # Extract compressed files in ZIP archives
                        zip # Create compressed ZIP archives
                        xz # General-purpose data compression

                        yt-dlp # Download videos from YouTube and other sites
                        ffmpeg # Complete solution to record, convert and stream audio and video
                        neofetch # System information tool
                        redis # In-memory data structure store

                        # System monitoring and performance tools
                        btop # Resource monitor that shows usage and stats
                        bandwhich # Display current network utilization by process
                        iperf3 # Network bandwidth measurement tool
                        iproute2mac # Linux iproute2 for macOS (includes ss command)

                        # Development utilities
                        jless # Command-line JSON viewer
                        yj # Convert between YAML, TOML, JSON, and HCL
                        git-extras # Extra Git utilities
                        dive # Tool for exploring Docker image layers
                        dua # View disk space usage and delete unwanted data

                        # Node.js CLI tools
                        bumpp # Interactive CLI to bump package.json version
                        taze # Modern CLI to keep dependencies up-to-date

                        kubectl # Kubernetes command-line tool
                        awscli2 # AWS Command Line Interface v2
                        google-cloud-sdk # Google Cloud SDK
                        terraform # Infrastructure as code tool
                        infisical # Open-source secret management platform
                        k9s # Terminal UI to interact with Kubernetes clusters
                        kind # Run local Kubernetes clusters using Docker
                      ])
                      ++ (with inputs.nix-casks.packages.${pkgs.system}; [
                        cursor # AI-powered code editor
                        discord # Voice and text chat for gamers
                        figma # Collaborative interface design tool
                        ghostty # Fast, feature-rich, and cross-platform terminal emulator
                        little-snitch # Network monitor and firewall
                        linear-linear # Issue tracking and project management
                        notion # All-in-one workspace
                        obsidian # Knowledge management and note-taking
                        ollama-app # Open-source AI model serving platform
                        orbstack # Fast, light, simple Docker & Linux on macOS
                        raycast # Launcher and productivity tool
                        signal # Private messenger
                        slack # Team communication and collaboration
                        stats # System monitor for the menu bar
                        aldente # Battery charge limiter for MacBooks
                        tableplus # Database management tool
                        tunnelblick # OpenVPN client
                        the-unarchiver # Archive extraction utility
                        vlc # Media player
                        whatsapp_beta # WhatsApp messaging (beta version)
                        protonvpn # VPN service
                      ]);

                    file = {
                      ".hushlogin".source = pkgs.emptyFile;
                    };
                  };

                  # https://github.com/konradmalik/dotfiles/blob/main/hosts/common/modules/aerospace.nix
                  # services = {
                  #   aerospace = {
                  #     enable = false;
                  #   };
                  # };

                  targets.darwin.defaults = {
                    "com.apple.WindowManager".GloballyEnabled = false;
                    "com.apple.controlcenter".NowPlaying = false;
                    "com.apple.LaunchServices".LSQuarantine = false;
                    "com.apple.SoftwareUpdate".AutomaticallyInstallMacOSUpdates = false;

                    "com.apple.dock" = {
                      autohide = true;
                      autohide-delay = 0.0;
                      autohide-time-modifier = 0.5;
                      expose-animation-duration = 0.5;
                      enable-spring-load-actions-on-all-items = true;

                      mru-spaces = false;
                      appswitcher-all-displays = true;
                      orientation = "left";

                      # Hot corners
                      # Possible values:
                      #  0: no-op
                      #  1: no-op
                      #  2: Mission Control
                      #  3: Show application windows
                      #  4: Desktop
                      #  5: Start screen saver
                      #  6: Disable screen saver
                      #  7: Dashboard
                      # 10: Put display to sleep
                      # 11: Launchpad
                      # 12: Notification Center
                      # 13: Lock Screen

                      wvous-tl-corner = 1; # disabled
                      wvous-bl-corner = 1; # disabled
                      wvous-tr-corner = 11; # Launchpad
                      wvous-br-corner = 2; # Mission control

                      tilesize = 45;
                      largesize = 70;
                      magnification = true;

                      show-process-indicators = true;
                      show-recents = false;
                      showhidden = false;
                    };

                    "com.apple.AppleMultitouchTrackpad" = {
                      Clicking = true;
                    };

                    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
                      Clicking = true;
                    };

                    "com.apple.menuextra.clock" = {
                      FlashDateSeparators = true;
                      Show24Hour = true;
                    };

                    "com.apple.loginwindow" = {
                      SHOWFULLNAME = true;
                      GuestEnabled = false;
                      autoLoginUser = user.name;
                    };

                    "com.apple.finder" = {
                      AppleShowAllFiles = true;
                      AppleShowAllExtensions = true;
                      ShowStatusBar = true;
                      ShowPathbar = true;
                      FXEnableExtensionChangeWarning = false;
                      FXDefaultSearchScope = "SCcf";
                      FXPreferredViewStyle = "clmv";
                      FXRemoveOldTrashItems = true;
                      _FXSortFoldersFirst = true;
                      ShowRemovableMediaOnDesktop = false;
                      ShowExternalHardDrivesOnDesktop = false;
                      QuitMenuItem = true;
                      # Set Home as the default location for new Finder windows
                      # For other paths, use `PfLo` and `file:///full/path/here/`
                      NewWindowTarget = "Home";
                    };

                    NSGlobalDomain = {
                      AppleShowAllFiles = true;
                      AppleShowAllExtensions = true;
                      AppleSpacesSwitchOnActivate = true;

                      AppleMeasurementUnits = "Centimeters";
                      AppleMetricUnits = true;
                      AppleTemperatureUnit = "Celsius";

                      NSDocumentSaveNewDocumentsToCloud = false;
                      NSNavPanelExpandedStateForSaveMode = true;
                      NSNavPanelExpandedStateForSaveMode2 = true;

                      NSAutomaticCapitalizationEnabled = false;
                      NSAutomaticDashSubstitutionEnabled = false;
                      NSAutomaticPeriodSubstitutionEnabled = false;
                      NSAutomaticQuoteSubstitutionEnabled = false;
                      NSAutomaticSpellingCorrectionEnabled = false;

                      AppleKeyboardUIMode = 3;
                      ApplePressAndHoldEnabled = false;
                      InitialKeyRepeat = 10;
                      KeyRepeat = 1;

                      "com.apple.trackpad.scaling" = 3.0;
                      "com.apple.mouse.tapBehavior" = 1;
                      "com.apple.sound.beep.volume" = 0.0;
                      "com.apple.sound.beep.feedback" = 0;
                    };

                    ".GlobalPreferences" = {
                      "com.apple.mouse.scaling" = 3.0;
                    };

                    CustomUserPreferences = {
                      "com.apple.TextInputMenu" = {
                        visible = false;
                      };

                      # Set Transmission as default for torrents and magnet links
                      "com.apple.LaunchServices" = {
                        LSHandlers = [
                          {
                            LSHandlerContentType = "org.bittorrent.torrent";
                            LSHandlerRoleAll = "org.m0k.transmission";
                          }
                          {
                            LSHandlerURLScheme = "magnet";
                            LSHandlerRoleAll = "org.m0k.transmission";
                          }
                          {
                            LSHandlerContentType = "public.json";
                            LSHandlerRoleAll = "dev.zed.Zed";
                          }
                        ];
                      };

                      # Setting Safari preferences requires Full Disk Access for the app running this process.
                      # Enable Full Disk Access for that app in System Preferences > Security & Privacy > Privacy > Full Dis Access
                      # Full Disk Access is required because Safari is sandboxed and because of macOS's System Integrit Protection.
                      # Read more: https://lapcatsoftware.com/articles/containers.html
                      "com.apple.Safari" = {
                        HomePage = "about:blank";
                        NewWindowBehavior = true;
                        NewTabBehavior = true;
                        ShowFullURLInSmartSearchField = true;
                        IncludeInternalDebugMenu = true;
                        IncludeDevelopMenu = true;
                        SendDoNotTrackHTTPHeader = true;
                        SuppressSearchSuggestions = true;
                        InstallExtensionUpdatesAutomatically = true;
                        AutoOpenSafeDownloads = false;
                        UniversalSearchEnabled = false;
                        WebKitDeveloperExtras = true;
                        WebKitDeveloperExtrasEnabledPreferenceKey = true;
                        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
                      };
                      "com.apple.desktopservices" = {
                        # Avoid creating .DS_Store files on network or USB volumes
                        DSDontWriteNetworkStores = true;
                        DSDontWriteUSBStores = true;
                      };
                      "com.apple.ImageCapture" = {
                        # Prevent Photos from opening automatically when devices are plugged in
                        disableHotPlug = true;
                      };
                      "com.apple.screencapture" = {
                        location = "~/Downloads/screenshots";
                        type = "png";
                      };
                      "com.apple.AdLib" = {
                        allowApplePersonalizedAdvertising = false;
                      };
                      "com.apple.print.PrintingPrefs" = {
                        # Automatically quit printer app once the print jobs complete
                        "Quit When Finished" = true;
                      };
                      "com.apple.screensaver" = {
                        # Require password immediately after sleep or screen saver begins
                        askForPassword = 1;
                        askForPasswordDelay = 0;
                      };
                      "com.apple.symbolichotkeys" = {
                        AppleSymbolicHotKeys = {
                          # Disabled hotkeys
                          "7" = {
                            enabled = false;
                          };
                          "8" = {
                            enabled = false;
                          };
                          "9" = {
                            enabled = false;
                          };
                          # Application windows
                          "10" = {
                            enabled = false;
                          };
                          # Show Desktop
                          "11" = {
                            enabled = false;
                          };
                          # Hide and show all windows
                          "12" = {
                            enabled = false;
                          };
                          # Look up in Dictionary
                          "13" = {
                            enabled = false;
                          };
                          # Decrease display brightness
                          "21" = {
                            enabled = false;
                          };
                          # Increase display brightness
                          "25" = {
                            enabled = false;
                          };
                          # Mission Control
                          "26" = {
                            enabled = false;
                          };
                          # Move left a space
                          "28" = {
                            enabled = false;
                          };
                          # Move right a space
                          "29" = {
                            enabled = false;
                          };
                          # Turn VoiceOver on or off
                          "36" = {
                            enabled = false;
                          };
                          # Turn Dock Hiding On/Off
                          "52" = {
                            enabled = false;
                          };
                          # Show Launchpad
                          "57" = {
                            enabled = false;
                          };
                          # Show Notification Center
                          "59" = {
                            enabled = false;
                          };
                          # Show Spotlight search
                          "60" = {
                            enabled = false;
                          };
                          # Show Finder search window
                          "61" = {
                            enabled = false;
                          };
                          # Show Spotlight search (alternate)
                          "64" = {
                            enabled = false;
                          };
                          # Show Finder search window (alternate)
                          "65" = {
                            enabled = false;
                          };
                          # Move focus to menu bar
                          "159" = {
                            enabled = false;
                          };
                          # Move focus to window toolbar
                          "162" = {
                            enabled = false;
                          };
                          # Change the way Tab moves focus
                          "175" = {
                            enabled = false;
                          };
                          # Turn focus following on/off
                          "190" = {
                            enabled = false;
                          };
                          # Restore windows when quitting and re-opening apps
                          "215" = {
                            enabled = false;
                          };
                          # Show Dock
                          "216" = {
                            enabled = false;
                          };
                          # Auto-hide Dock
                          "217" = {
                            enabled = false;
                          };
                          # Show recent applications in Dock
                          "218" = {
                            enabled = false;
                          };
                          # Show Launchpad
                          "219" = {
                            enabled = false;
                          };
                          # Show Notification Center
                          "222" = {
                            enabled = false;
                          };
                          # Turn Do Not Disturb on/off
                          "223" = {
                            enabled = false;
                          };
                          # Turn VoiceOver on or off
                          "224" = {
                            enabled = false;
                          };
                          # Zoom in
                          "225" = {
                            enabled = false;
                          };
                          # Zoom out
                          "226" = {
                            enabled = false;
                          };
                          # Turn zoom on or off
                          "227" = {
                            enabled = false;
                          };
                          # Turn image smoothing on or off
                          "228" = {
                            enabled = false;
                          };
                          # Increase contrast
                          "229" = {
                            enabled = false;
                          };
                          # Decrease contrast
                          "230" = {
                            enabled = false;
                          };
                          # Turn high contrast on or off
                          "231" = {
                            enabled = false;
                          };
                          # Invert colors
                          "232" = {
                            enabled = false;
                          };
                          # Turn keyboard access on or off
                          "233" = {
                            enabled = false;
                          };
                          # Change keyboard access behavior
                          "235" = {
                            enabled = false;
                          };
                          # Turn VoiceOver on or off
                          "237" = {
                            enabled = false;
                          };
                          # Turn VoiceOver on or off
                          "238" = {
                            enabled = false;
                          };
                          # Turn VoiceOver on or off
                          "239" = {
                            enabled = false;
                          };
                          # Move focus to window drawer
                          "240" = {
                            enabled = false;
                          };
                          # Move focus to status menus
                          "241" = {
                            enabled = false;
                          };
                          # Move focus to Dock
                          "242" = {
                            enabled = false;
                          };
                          # Move focus to active or next window
                          "243" = {
                            enabled = false;
                          };
                          # Move focus to previous window
                          "244" = {
                            enabled = false;
                          };
                          # Move focus to toolbar
                          "245" = {
                            enabled = false;
                          };
                          # Move focus to floating window
                          "246" = {
                            enabled = false;
                          };
                          # Change the way Tab moves focus
                          "247" = {
                            enabled = false;
                          };
                          # Show Help menu
                          "248" = {
                            enabled = false;
                          };
                          # Turn Dock hiding on or off
                          "249" = {
                            enabled = false;
                          };
                          # Move focus to window toolbar
                          "250" = {
                            enabled = false;
                          };
                          # Move focus to floating window
                          "251" = {
                            enabled = false;
                          };
                          # Show Character Palette
                          "256" = {
                            enabled = false;
                          };
                          # Select next input source
                          "257" = {
                            enabled = false;
                          };
                          # Select previous input source
                          "258" = {
                            enabled = false;
                          };

                          "27" = {
                            enabled = true;
                            value = {
                              parameters = [
                                65535 # Character
                                10 # Key code
                                1048576 # Modifier flags
                              ];
                              type = "standard";
                            };
                          };
                          "31" = {
                            enabled = true;
                            value = {
                              parameters = [
                                52 # Character
                                21 # Key code
                                1441792 # Modifier flags
                              ];
                              type = "standard";
                            };
                          };
                          "37" = {
                            enabled = true;
                            value = {
                              parameters = [
                                65535 # Character
                                103 # Key code
                                8519680 # Modifier flags
                              ];
                              type = "standard";
                            };
                          };
                        };
                      };
                      "org.m0k.transmission" = {
                        "download-dir" = "/Users/${user.name}/Documents/transmission";
                        "incomplete-dir" = "/Users/${user.name}/Documents/transmission/.incomplete";
                        "incomplete-dir-enabled" = true;
                        "watch-dir-enabled" = true;
                        "peer-port-random-on-start" = true;
                        "watch-dir" = "/Users/${user.name}/Downloads";
                        "trash-original-torrent-files" = true;
                        "upload-limit-enabled" = true;
                        "speed-limit-down-enabled" = false;
                        "speed-limit-up-enabled" = true;
                        "speed-limit-up" = 1;
                        "upload-limit" = 1;
                        WarningLegal = false;
                      };
                    };
                  };

                  programs = {
                    home-manager = {
                      enable = true;
                    };

                    neovim = {
                      enable = true;
                      defaultEditor = true;
                      vimAlias = true;
                    };

                    lazygit = {
                      enable = true;
                      package = null;
                      settings = {
                        notARepository = "skip";
                        promptToReturnFromSubprocess = false;
                        os.editPreset = "nvim";
                        git.overrideGpg = true;
                        gui = {
                          showRandomTip = false;
                          nerdFontsVersion = "3";
                        };
                      };
                    };

                    ghostty = {
                      enable = true;
                      package = null;
                      settings = {
                        theme = "catppuccin-mocha";
                        scrollback-limit = 10 * 10000000;

                        mouse-hide-while-typing = true;
                        focus-follows-mouse = true;

                        window-height = 221;
                        window-width = 221;
                        window-colorspace = "display-p3";

                        keybind = [
                          "cmd+up=jump_to_prompt:-1"
                          "cmd+down=jump_to_prompt:1"
                          "shift+enter=text:\n"
                        ];
                      };
                    };

                    ssh = {
                      enable = true;
                      addKeysToAgent = "yes";
                      controlMaster = "auto";
                      controlPersist = "72000";
                      serverAliveInterval = 60;
                      extraConfig = "UseKeychain yes";

                      matchBlocks = {
                        "github.com" = {
                          hostname = "ssh.github.com";
                          port = 443;
                        };

                        "nivalis.macmini" = {
                          hostname = "macmini-nivalis.end-centauri.ts.net";
                          user = "nivalis";
                          forwardAgent = true;
                          setEnv = {
                            TERM = "xterm-256color";
                          };
                        };

                        "pimpup.nginx" = {
                          hostname = "51.15.210.84";
                          user = "root";
                          forwardAgent = true;
                          setEnv = {
                            TERM = "xterm-256color";
                          };
                        };

                        "cleanco.nginx" = {
                          hostname = "163.172.174.239";
                          user = "root";
                          forwardAgent = true;
                          setEnv = {
                            TERM = "xterm-256color";
                          };
                        };

                        "geomex" = {
                          hostname = "62.210.89.221";
                          user = "ubuntu";
                          forwardAgent = true;
                        };
                      };
                    };

                    broot = {
                      enable = true;
                      settings = {
                        default_flags = "g";
                        quit_on_last_cancel = true;
                        enable_kitty_keyboard = false;
                        lines_before_match_in_preview = 1;
                        lines_after_match_in_preview = 1;
                        imports = [
                          "verbs.hjson"
                          {
                            luma = [
                              "dark"
                              "unknown"
                            ];
                            file = "skins/catppuccin-macchiato.hjson";
                          }

                          {
                            luma = [
                              "light"
                            ];
                            file = "skins/white.hjson";
                          }
                        ];
                      };
                    };

                    zed-editor = {
                      enable = true;
                      extensions = [
                        "catppuccin"
                        "nix"
                        "dockerfile"
                        "sql"
                        "terraform"
                        "catppuccin-icons"
                        "prisma"
                        "html"
                        "yaml"
                        "zig"
                      ];
                      userKeymaps = [
                        {
                          context = "Workspace";
                          use_key_equivalents = true;
                          bindings = {
                            "cmd-shift-d" = "editor::SelectAllMatches";
                          };
                        }
                        {
                          context = "Editor";
                          use_key_equivalents = true;
                          bindings = {
                            "cmd-l" = "editor::Rename";
                            "cmd-y" = "editor::GoToDiagnostic";
                            "cmd-shift-y" = "editor::GoToPreviousDiagnostic";
                            "cmd-o" = "editor::RevealInFileManager";
                            "cmd-g" = "go_to_line::Toggle";
                          };
                        }
                        {
                          context = "Pane";
                          bindings = {
                            "cmd-1" = [
                              "pane::ActivateItem"
                              0
                            ];
                            "cmd-2" = [
                              "pane::ActivateItem"
                              1
                            ];
                            "cmd-3" = [
                              "pane::ActivateItem"
                              2
                            ];
                            "cmd-4" = [
                              "pane::ActivateItem"
                              3
                            ];
                            "cmd-5" = [
                              "pane::ActivateItem"
                              4
                            ];
                            "cmd-6" = [
                              "pane::ActivateItem"
                              5
                            ];
                            "cmd-7" = [
                              "pane::ActivateItem"
                              6
                            ];
                            "cmd-8" = [
                              "pane::ActivateItem"
                              7
                            ];
                            "cmd-9" = [
                              "pane::ActivateItem"
                              8
                            ];
                            "cmd-0" = [
                              "pane::ActivateItem"
                              9
                            ];
                          };
                        }
                        {
                          context = "ProjectPanel";
                          bindings = {
                            "cmd-1" = [
                              "pane::ActivateItem"
                              0
                            ];
                            "cmd-2" = [
                              "pane::ActivateItem"
                              1
                            ];
                            "cmd-3" = [
                              "pane::ActivateItem"
                              2
                            ];
                            "cmd-4" = [
                              "pane::ActivateItem"
                              3
                            ];
                            "cmd-5" = [
                              "pane::ActivateItem"
                              4
                            ];
                            "cmd-6" = [
                              "pane::ActivateItem"
                              5
                            ];
                            "cmd-7" = [
                              "pane::ActivateItem"
                              6
                            ];
                            "cmd-8" = [
                              "pane::ActivateItem"
                              7
                            ];
                            "cmd-9" = [
                              "pane::ActivateItem"
                              8
                            ];
                            "cmd-0" = [
                              "pane::ActivateItem"
                              9
                            ];
                          };
                        }
                      ];
                      userSettings = {
                        agent = {
                          version = "2";
                          play_sound_when_agent_done = true;
                        };
                        theme = {
                          mode = "system";
                          light = "Catppuccin Mocha";
                          dark = "Catppuccin Mocha";
                        };
                        ui_font_features = {
                          calt = true;
                        };
                        icon_theme = "Catppuccin Mocha";
                        base_keymap = "VSCode";
                        restore_on_startup = "none";
                        show_whitespaces = "none";
                        max_tabs = 5;
                        ensure_final_newline_on_save = true;
                        format_on_save = "on";
                        relative_line_numbers = true;
                        hard_tabs = false;
                        tab_size = 2;
                        wrap_guides = [
                          80
                          120
                        ];
                        soft_wrap = "preferred_line_length";
                        preferred_line_length = 120;
                        extend_comment_on_newline = false;
                        close_on_file_delete = true;
                        on_last_window_closed = "quit_app";
                        when_closing_with_no_tabs = "close_window";
                        autosave = {
                          after_delay = {
                            milliseconds = 3000;
                          };
                        };
                        tab_bar = {
                          show = true;
                        };
                        file_finder = {
                          modal_max_width = "medium";
                        };
                        indent_guides = {
                          active_line_width = 2;
                          enabled = true;
                          coloring = "fixed";
                        };
                        tabs = {
                          file_icons = true;
                          git_status = true;
                          show_diagnostics = "all";
                        };
                        project_panel = {
                          dock = "right";
                          git_status = true;
                          show_diagnostics = "all";
                          default_width = 290;
                        };
                        git_panel = {
                          button = false;
                          dock = "right";
                        };
                        chat_panel = {
                          button = "never";
                          dock = "left";
                        };
                        outline_panel = {
                          button = false;
                          dock = "right";
                        };
                        notification_panel = {
                          button = false;
                          dock = "right";
                        };
                        terminal = {
                          button = false;
                          dock = "right";
                        };
                        collaboration_panel = {
                          dock = "left";
                        };
                        telemetry = {
                          diagnostics = false;
                          metrics = false;
                        };
                        calls = {
                          mute_on_join = true;
                          share_on_join = true;
                        };
                      };
                    };

                    git = {
                      enable = true;

                      userName = user.fullName;
                      userEmail = "5941125+${user.name}@users.noreply.github.com";

                      signing = {
                        format = "ssh";
                        key = "/Users/${user.name}/.ssh/id_rsa";
                        signByDefault = true;
                      };

                      lfs = {
                        enable = true;
                      };

                      extraConfig = {
                        user = {
                          username = user.name;
                        };

                        github = {
                          user = user.name;
                        };

                        core = {
                          editor = "nvim";
                          pager = "delta";
                          autocrlf = "input";
                          trustctime = false; # http://www.git-tower.com/blog/make-git-rebase-safe-on-osx
                          untrackedCache = true; # https://git-scm.com/docs/git-update-index#_untracked_cache
                          precomposeunicode = false; # http://michael-kuehnel.de/git/2014/11/21/git-mac-osx-and-german-umlaute.html
                          whitespace = "-trailing-space"; # Don't consider trailing space change as a cause for merge conflicts
                        };

                        apply = {
                          whitespace = "fix"; # Detect whitespace errors when applying a patch
                        };

                        branch = {
                          sort = "-committerdate";
                        };

                        color = {
                          ui = "auto";
                        };

                        column = {
                          ui = "auto";
                        };

                        commit = {
                          verbose = true;
                        };

                        diff = {
                          renames = "copies"; # Detect copies as well as renames
                          mnemonicPrefix = true; # Use better, descriptive initials (c, i, w) instead of a/b.
                          wordRegex = "."; # When using --word-diff, assume --word-diff-regex=.
                          submodule = "log"; # Display submodule-related information (commit listings)
                          algorithm = "histogram"; # much better algo
                        };

                        delta = {
                          line-numbers = true;
                          side-by-side = true;
                          features = "side-by-side line-numbers decorations";
                          whitespace-error-style = "22 reverse";
                        };

                        fetch = {
                          writeCommitGraph = true;
                          recurseSubmodules = "on-demand"; # Auto-fetch submodule changes
                        };

                        grep = {
                          break = true;
                          heading = true;
                          lineNumber = true;
                          extendedRegexp = true; # Consider most regexes to be ERE
                        };

                        help = {
                          autocorrect = "prompt";
                        };

                        interactive = {
                          diffFilter = "delta --color-only";
                          singleKey = true;
                        };

                        init = {
                          defaultBranch = "main";
                        };

                        log = {
                          abbrevCommit = true; # Use abbrev SHAs whenever possible
                          follow = true; # Automatically --follow when given a single path
                          decorate = false; # Disable decorate for reflog
                        };

                        pack = {
                          windowMemory = "2g";
                          packSizeLimit = "1g";
                        };

                        pull = {
                          rebase = true;
                        };

                        push = {
                          default = "simple"; # https://git-scm.com/docs/git-config#git-config-pushdefault
                          followTags = true;
                          autoSetupRemote = true;
                        };

                        merge = {
                          log = true; # Include summaries of merged commits in newly created merge commit messages
                          summary = true;
                          verbosity = 1;
                          conflictstyle = "zdiff3";
                        };

                        mergeTool = { };

                        rebase = {
                          autoSquash = true; # auto squash fixup commits
                          autoStash = true;
                          updateRefs = true; # takes stacked refs in a branch and makes sure they're also moved when a branch is rebased
                        };

                        rerere = {
                          enabled = true;
                          autoUpdate = true;
                        };

                        status = {
                          submoduleSummary = true;
                        };

                        submodule = {
                          recurse = true;
                        };

                        tag = {
                          gpgSign = true;
                          sort = "version:refname"; # Sort tags as version numbers whenever applicable, so 1.10.2 is AFTER 1.2.0.
                        };

                      };

                      ignores = [
                        "node_modules/"
                        "jspm_packages/"
                        "web_modules/"
                        ".npm/"
                        "*.tsbuildinfo"
                        "*.eslintcache"
                        ".node_repl_history"
                        ".yarn-integrity"
                        ".env"
                        ".env.test"
                        ".env.production"
                        "logs"
                        "*.log"
                        "npm-debug.log*"
                        "yarn-debug.log*"
                        "yarn-error.log*"
                        "lerna-debug.log*"
                        ".pnpm-debug.log*"
                        "report.[0-9]*.[0-9]*.[0-9]*.[0-9]*.json"
                        "._*"
                        ".cache"
                        ".Spotlight-V100"
                        ".Trashes"
                        ".TemporaryItems"
                        ".AppleDouble"
                        ".AppleDB"
                        ".AppleDesktop"
                        "Network Trash Folder"
                        "Temporary Items"
                        ".apdisk"
                        ".LSOverride"
                        ".DS_Store"
                        "desktop.ini"
                        "ehthumbs.db"
                        "Thumbs.db"
                        ".DocumentRevisions-V100"
                        ".fseventsd"
                        ".VolumeIcon.icns"
                        ".com.apple.timemachine.donotpresent"
                        ".svn/*"
                        "*.swp"
                        "svn-commit.*"
                        "pids"
                        "*.pid"
                        "*.seed"
                        "*.pid.lock"
                        "coverage"
                        "*.lcov"
                        "lib-cov"
                        ".nyc_output"
                        ".cache"
                        ".parcel-cache"
                        ".next"
                        ".claude"
                        ".serena"
                        ".nuxt"
                        "dist"
                        "out"
                        ".cache/"
                        ".serverless/"
                        ".vuepress/dist"
                        ".yarn/cache"
                        ".yarn/unplugged"
                        ".yarn/build-state.yml"
                        ".yarn/install-state.gz"
                        ".pnp.*"
                      ];

                      attributes = [
                        "* text=auto"
                        "*.lockb binary diff=lockb"
                      ];

                      aliases = {
                        a = "add --all";
                        ai = "add --interactive";

                        ba = "branch --all";
                        br = "branch --remotes";
                        bl = "branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";

                        c = "commit";
                        cam = "commit --all --message";

                        cl = "clone --recursive";
                        cld = "clone --depth 1";

                        f = "fetch";
                        fo = "fetch origin";
                        fu = "fetch upstream";

                        m = "merge";
                        ma = "merge --abort";
                        mc = "merge --continue";
                        ms = "merge --skip";

                        rb = "rebase";
                        rba = "rebase --abort";
                        rbc = "rebase --continue";
                        rbi = "rebase --interactive";
                        rbs = "rebase --skip";

                        o = "switch";
                        ob = "checkout -b";
                        om = "switch main";

                        ps = "push";
                        psf = "push --force-with-lease";
                        psff = "push --force";
                        pl = "pull --recurse-submodules";
                        pld = "pull --recurse-submodules --depth 1";

                        re = "reset";
                        rh = "reset HEAD";
                        reh = "reset --hard";
                        res = "reset --soft";

                        s = "status -s";
                        sb = "status -s -b";

                        ss = "stash save";
                        sa = "stash apply";
                        sd = "stash drop";
                        sc = "stash clear";
                        sl = "stash list";
                        sp = "stash pop";
                      };
                    };
                  };
                };
            };
          }
        ];
      }) machines;
    };
}
