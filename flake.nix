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
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
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

      configuration =
        { pkgs, ... }:
        {
          environment = {
            variables = {
              EDITOR = "nvim";
              VISUAL = "nvim";
            };

            shells = with pkgs; [ zsh ];

            systemPackages = with pkgs; [
              vim
              nil
              nixd
              neovim
              eza
              htop
              jq
              tree
              wget
              zoxide
              lazygit
              cmake
              ninja
              deno
              bun
              delta
              pipx
              uv
              fnm
              just
              neofetch
              redis
              gh
              go
              kubectl
              rustup
              terraform
              k9s
              ffmpeg
              coreutils
              gnugrep
              gnused
              gawk
              rsync
              jq
              unrar
              fd
              zsh
            ];
          };

          homebrew = {
            enable = true;
            brews = [
              "mas"
              "curl" # do not install curl via nixpkgs, it's not working well on MacOS!
            ];

            casks = [
              "nikitabobko/tap/aerospace"

              "cursor"
              "discord"
              "figma"
              "ghostty"
              "little-snitch"
              "messenger"
              "notion"
              "obsidian"
              "orbstack"
              "raycast"
              "signal"
              "slack"
              "stats"
              "steam"
              "tunnelblick"
              "the-unarchiver"
              "tailscale-app"
              "transmission"
              "vlc"
              "whatsapp@beta"
              "zed"
              "zoom"
            ];
            onActivation = {
              autoUpdate = false;
              cleanup = "zap";
            };
          };

          nix.settings = {
            experimental-features = "nix-command flakes";
            trusted-users = [
              "root"
              user.name
              "@admin"
            ];
          };

          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
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

            defaults = {
              WindowManager.GloballyEnabled = false;
              controlcenter.NowPlaying = false;

              dock = {
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

                tilesize = 55;
                largesize = 75;
                magnification = true;

                show-process-indicators = false;
                show-recents = false;
                showhidden = false;
              };

              trackpad = {
                Clicking = true;
              };

              menuExtraClock = {
                FlashDateSeparators = true;
                Show24Hour = true;
              };

              loginwindow = {
                SHOWFULLNAME = true;
                GuestEnabled = false;
                autoLoginUser = user.name;
              };

              finder = {
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                ShowStatusBar = true;
                ShowPathbar = true;
                FXEnableExtensionChangeWarning = false;
                FXDefaultSearchScope = "SCcf";
                FXPreferredViewStyle = "clmv";
                FXRemoveOldTrashItems = true;
                NewWindowTarget = "Home";
                ShowRemovableMediaOnDesktop = false;
                ShowExternalHardDrivesOnDesktop = false;
                QuitMenuItem = true;
              };

              LaunchServices.LSQuarantine = false;

              NSGlobalDomain = {
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                AppleTemperatureUnit = "Celsius";
                AppleSpacesSwitchOnActivate = true;
                NSAutomaticCapitalizationEnabled = false;
                NSAutomaticPeriodSubstitutionEnabled = false;
                NSAutomaticDashSubstitutionEnabled = false;
                NSAutomaticQuoteSubstitutionEnabled = false;
                NSAutomaticSpellingCorrectionEnabled = false;
                NSDocumentSaveNewDocumentsToCloud = false;

                ApplePressAndHoldEnabled= false;
                InitialKeyRepeat = 15;
                KeyRepeat = 2;

                "com.apple.trackpad.scaling" = 3.0;
                "com.apple.mouse.tapBehavior" = 1;
              };

              ".GlobalPreferences" = {
                "com.apple.mouse.scaling" = 3.0;
              };

              CustomUserPreferences = {
                # Hide Input menu from menu bar
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
                  ];
                };

                # Setting Safari preferences requires Full Disk Access for the app running this process.
                # Enable Full Disk Access for that app in System Preferences > Security & Privacy > Privacy > Full Dis Access
                # Full Disk Access is required because Safari is sandboxed and because of macOS’s System Integrit Protection.
                # Read more: https://lapcatsoftware.com/articles/containers.html
                "com.apple.Safari" ={
                  NewWindowBehavior = true;
                  NewTabBehavior = true;
                  ShowFullURLInSmartSearchField = true;
                  IncludeInternalDebugMenu = true;
                  IncludeDevelopMenu = true;
                  SendDoNotTrackHTTPHeader = true;
                  WebKitDeveloperExtras = true;
                  WebKitDeveloperExtrasEnabledPreferenceKey = true;
                  "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
                };
                "com.apple.desktopservices" = {
                  # Avoid creating .DS_Store files on network or USB volumes
                  DSDontWriteNetworkStores = true;
                  DSDontWriteUSBStores = true;
                };
                "com.apple.symbolichotkeys" = {
                  AppleSymbolicHotKeys = {
                    # Disabled hotkeys - removing parameters since they're not needed
                    "7" = { enabled = false; };
                    "8" = { enabled = false; };
                    "9" = { enabled = false; };
                    # Application windows
                    "10" = { enabled = false; };
                    # Show Desktop
                    "11" = { enabled = false; };
                    # Hide and show all windows
                    "12" = { enabled = false; };
                    # Look up in Dictionary
                    "13" = { enabled = false; };
                    # Decrease display brightness
                    "21" = { enabled = false; };
                    # Increase display brightness
                    "25" = { enabled = false; };
                    # Mission Control
                    "26" = { enabled = false; };
                    # Move left a space
                    "28" = { enabled = false; };
                    # Move right a space
                    "29" = { enabled = false; };
                    # Turn VoiceOver on or off
                    "36" = { enabled = false; };
                    # Turn Dock Hiding On/Off
                    "52" = { enabled = false; };
                    # Show Launchpad
                    "57" = { enabled = false; };
                    # Show Notification Center
                    "59" = { enabled = false; };
                    # Show Spotlight search
                    "60" = { enabled = false; };
                    # Show Finder search window
                    "61" = { enabled = false; };
                    # Show Spotlight search (alternate)
                    "64" = { enabled = false; };
                    # Show Finder search window (alternate)
                    "65" = { enabled = false; };
                    # Move focus to menu bar
                    "159" = { enabled = false; };
                    # Move focus to window toolbar
                    "162" = { enabled = false; };
                    # Change the way Tab moves focus
                    "175" = { enabled = false; };
                    # Turn focus following on/off
                    "190" = { enabled = false; };
                    # Restore windows when quitting and re-opening apps
                    "215" = { enabled = false; };
                    # Show Dock
                    "216" = { enabled = false; };
                    # Auto-hide Dock
                    "217" = { enabled = false; };
                    # Show recent applications in Dock
                    "218" = { enabled = false; };
                    # Show Launchpad
                    "219" = { enabled = false; };
                    # Show Notification Center
                    "222" = { enabled = false; };
                    # Turn Do Not Disturb on/off
                    "223" = { enabled = false; };
                    # Turn VoiceOver on or off
                    "224" = { enabled = false; };
                    # Zoom in
                    "225" = { enabled = false; };
                    # Zoom out
                    "226" = { enabled = false; };
                    # Turn zoom on or off
                    "227" = { enabled = false; };
                    # Turn image smoothing on or off
                    "228" = { enabled = false; };
                    # Increase contrast
                    "229" = { enabled = false; };
                    # Decrease contrast
                    "230" = { enabled = false; };
                    # Turn high contrast on or off
                    "231" = { enabled = false; };
                    # Invert colors
                    "232" = { enabled = false; };
                    # Turn keyboard access on or off
                    "233" = { enabled = false; };
                    # Change keyboard access behavior
                    "235" = { enabled = false; };
                    # Turn VoiceOver on or off
                    "237" = { enabled = false; };
                    # Turn VoiceOver on or off
                    "238" = { enabled = false; };
                    # Turn VoiceOver on or off
                    "239" = { enabled = false; };
                    # Move focus to window drawer
                    "240" = { enabled = false; };
                    # Move focus to status menus
                    "241" = { enabled = false; };
                    # Move focus to Dock
                    "242" = { enabled = false; };
                    # Move focus to active or next window
                    "243" = { enabled = false; };
                    # Move focus to previous window
                    "244" = { enabled = false; };
                    # Move focus to toolbar
                    "245" = { enabled = false; };
                    # Move focus to floating window
                    "246" = { enabled = false; };
                    # Change the way Tab moves focus
                    "247" = { enabled = false; };
                    # Show Help menu
                    "248" = { enabled = false; };
                    # Turn Dock hiding on or off
                    "249" = { enabled = false; };
                    # Move focus to window toolbar
                    "250" = { enabled = false; };
                    # Move focus to floating window
                    "251" = { enabled = false; };
                    # Show Character Palette
                    "256" = { enabled = false; };
                    # Select next input source
                    "257" = { enabled = false; };
                    # Select previous input source
                    "258" = { enabled = false; };

                    "27" = {
                      enabled = true;
                      value = {
                        parameters = [
                          65535  # Character
                          10     # Key code
                          1048576  # Modifier flags
                        ];
                        type = "standard";
                      };
                    };
                    "31" = {
                      enabled = true;
                      value = {
                        parameters = [
                          52      # Character
                          21      # Key code
                          1441792 # Modifier flags
                        ];
                        type = "standard";
                      };
                    };
                    "37" = {
                      enabled = true;
                      value = {
                        parameters = [
                          65535   # Character
                          103     # Key code
                          8519680 # Modifier flags
                        ];
                        type = "standard";
                      };
                    };
                  };
                };
                "org.m0k.transmission" = {
                  DownloadLocationConstant = true;
                  DownloadFolder = "/Users/${user.name}/Documents/transmission";
                  IncompleteDownloadFolder = "/Users/${user.name}/Documents/transmission/.incomplete";
                  UseIncompleteDownloadFolder = true;
                  AutoImport = true;
                  RandomPort = true;
                  AutoImportDirectory = "/Users/${user.name}/Downloads";
                  DeleteOriginalTorrent = true;
                  CheckUpload = true;
                  CheckRemoveDownloading = true;
                  CheckQuitDownloading = true;
                  AutoSize = true;
                  DownloadAsk = false;
                  InfoVisible = false;
                  MagnetOpenAsk = false;
                  SpeedLimitDownloadEnabled = false;
                  SpeedLimitUploadEnabled = true;
                  SpeedLimitUpload = 1;
                  UploadLimit = true;
                  WarningLegal = false;
                };
              };
            };
          };
        };

    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#pnodet
      darwinConfigurations.${user.name} = nix-darwin.lib.darwinSystem {
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

              users.${user.name} =
                { pkgs, ... }:
                {
                  home = {
                    username = user.name;
                    homeDirectory = "/Users/${user.name}";
                    stateVersion = "25.05";

                    file = {
                      ".hushlogin".source = pkgs.emptyFile;
                    };
                  };

                  programs = {
                    home-manager = {
                      enable = true;
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

                    ssh = {
                      enable = true;
                      addKeysToAgent = "yes";
                      controlMaster = "auto";
                      controlPersist = "72000";
                      serverAliveInterval = 60;

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
                          play_sound_when_agent_done = true;
                        };
                        theme = {
                          mode = "system";
                          light = "Catppuccin Mocha";
                          dark = "Catppuccin Mocha";
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

                    neovim = {
                      enable = true;
                      defaultEditor = true;
                      vimAlias = true;
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
                          trustctime = false; # http://www.git-tower.com/blog/make-git-rebase-safe-on-osx
                          untrackedCache = true; # https://git-scm.com/docs/git-update-index#_untracked_cache
                          precomposeunicode = false; # http://michael-kuehnel.de/git/2014/11/21/git-mac-osx-and-german-umlaute.html
                          whitespace = "-trailing-space"; # Don't consider trailing space change as a cause for merge conflicts
                        };

                        pack = {
                          windowMemory = "2g";
                          packSizeLimit = "1g";
                        };

                        help = {
                          autocorrect = 1;
                        };

                        branch = {
                          sort = "-committerdate";
                        };

                        push = {
                          default = "simple"; # https://git-scm.com/docs/git-config#git-config-pushdefault
                          followTags = true;
                          autoSetupRemote = true;
                        };

                        pull = {
                          rebase = true;
                        };

                        rebase = {
                          autostash = true;
                        };

                        init = {
                          defaultBranch = "main";
                        };

                        merge = {
                          log = true; # Include summaries of merged commits in newly created merge commit messages
                          summary = true;
                          verbosity = 1;
                          conflictstyle = "diff3";
                        };

                        mergeTool = { };

                        apply = {
                          whitespace = "fix"; # Detect whitespace errors when applying a patch
                        };

                        rerere = {
                          enabled = true;
                          autoUpdate = true;
                        };

                        grep = {
                          break = true;
                          heading = true;
                          lineNumber = true;
                          extendedRegexp = true; # Consider most regexes to be ERE
                        };

                        log = {
                          abbrevCommit = true; # Use abbrev SHAs whenever possible
                          follow = true; # Automatically --follow when given a single path
                          decorate = false; # Disable decorate for reflog
                        };

                        fetch = {
                          writeCommitGraph = true;
                          recurseSubmodules = "on-demand"; # Auto-fetch submodule changes
                        };

                        interactive = {
                          diffFilter = "delta --color-only";
                        };

                        diff = {
                          renames = "copies"; # Detect copies as well as renames
                          mnemonicPrefix = true; # Use better, descriptive initials (c, i, w) instead of a/b.
                          wordRegex = "."; # When using --word-diff, assume --word-diff-regex=.
                          submodule = "log"; # Display submodule-related information (commit listings)
                        };

                        delta = {
                          features = "side-by-side line-numbers decorations";
                          whitespace-error-style = "22 reverse";
                        };

                        tag = {
                          sort = "version:refname"; # Sort tags as version numbers whenever applicable, so 1.10.2 is AFTER 1.2.0.
                        };

                        color = {
                          ui = "auto";
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
      };
    };
}
