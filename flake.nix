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
              "transmission"
              "tailscale-app"
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
            ];
            dns = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          };

          programs = {
            # needed to Create /etc/zshrc that loads the nix-darwin environment.
            zsh.enable = true;
            # home-manager.enable = true;
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
                autohide-time-modifier = 0.0;
                expose-animation-duration = 0.01;

                mru-spaces = false;
                appswitcher-all-displays = true;
                orientation = "left";
                wvous-tl-corner = 1; # disabled
                wvous-bl-corner = 1; # disabled
                wvous-tr-corner = 11; # Launchpad
                wvous-br-corner = 2; # Mission control

                largesize = 64;
                magnification = true;
                show-recents = false;

                # persistent-apps = [
                #   "/Applications/Safari.app"
                #   "/Applications/Messages.app"
                #   "/Applications/FaceTime.app"
                #   "/Applications/Calendar.app"
                #   "/Applications/Music.app"
                #   "/Applications/System Settings.app"
                #   "/Applications/Transmission.app"
                #   "/Applications/Slack.app"
                #   "/Applications/Discord.app"
                #   "/Applications/Ghostty.app"
                #   "/Applications/Zed.app"
                #   "/Applications/WhatsApp.app"
                #   "/Applications/Messenger.app"
                #   "/Applications/Signal.app"
                #   "/Applications/Figma.app"
                # ];
                # persistent-others = [ "~/Downloads" ];
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
                NSAutomaticCapitalizationEnabled = false;
                NSAutomaticPeriodSubstitutionEnabled = false;
                NSAutomaticDashSubstitutionEnabled = false;
                NSAutomaticQuoteSubstitutionEnabled = false;
                NSAutomaticSpellingCorrectionEnabled = false;
                NSDocumentSaveNewDocumentsToCloud = false;
                InitialKeyRepeat = 10;
                KeyRepeat = 2;

                "com.apple.trackpad.scaling" = 3.0;
                "com.apple.mouse.tapBehavior" = 1;
              };

              ".GlobalPreferences" = {
                "com.apple.mouse.scaling" = 4.0;
              };

              CustomUserPreferences = {
                "com.apple.desktopservices" = {
                  # Avoid creating .DS_Store files on network or USB volumes
                  DSDontWriteNetworkStores = true;
                  DSDontWriteUSBStores = true;
                };
                "com.apple.symbolichotkeys" = {
                  AppleSymbolicHotKeys = {
                    "60" = {
                      enabled = false;
                    };
                    "61" = {
                      enabled = false;
                    };
                    "64" = {
                      enabled = false;
                    };
                    # Disable 'Cmd + Alt + Space' for Finder search window
                    "65" = {
                      enabled = false;
                    };
                    "27" = {
                      enabled = true;
                      value = {
                        parameters = [
                          32
                          49
                          262144
                        ];
                        type = "standard";
                      };
                    };
                  };
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
                        key = "/Users/pnodet/.ssh/id_rsa";
                        signByDefault = true;
                      };

                      extraConfig = {
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
