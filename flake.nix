{
  description = "macOS system flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      user = "pnodet";

      homeConfiguration =
        { pkgs, ... }:
        {
          home.username = user;
          home.homeDirectory = "/Users/${user}";
          home.stateVersion = "25.05";

          # Shell configuration - minimal since z4h handles most zsh setup
          programs.zsh = {
            enable = true;
            enableCompletion = false; # Handled by z4h
            enableAutosuggestions = false; # Handled by z4h
            syntaxHighlighting.enable = false; # Handled by z4h

            initExtra = ''
              # Source our custom functions
              [[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

              # Add completions for custom functions
              compdef _directories mcd
              compdef _default open
              compdef g='git'
            '';
          };

          # Environment variables moved from .zshrc
          home.sessionVariables = {
            # Core editor/pager settings
            EDITOR = "nvim";
            PAGER = "delta";
            MANPAGER = "nvim +Man!";
            MANOPT = "--no-hyphenation";
            MANWIDTH = "100";

            # Locale settings
            LANG = "en_US.UTF-8";
            LANGUAGE = "en_US.UTF-8";
            LC_COLLATE = "en_US.UTF-8";
            LC_CTYPE = "en_US.UTF-8";
            LC_MESSAGES = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";

            # Security and privacy
            GPG_TTY = "$TTY";
            DO_NOT_TRACK = "1";

            # Tool settings
            HOMEBREW_NO_ENV_HINTS = "1";
            PRISMA_HIDE_UPDATE_MESSAGE = "1";
            LESSCHARSET = "utf-8";

            # NPM defaults
            NPM_CONFIG_INIT_LICENSE = "GPL-3.0";
            NPM_CONFIG_INIT_VERSION = "0.0.0";
            NPM_CONFIG_SIGN_GIT_TAG = "true";

            # FZF styling
            FZF_DEFAULT_COLORS = "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4";
            FZF_DEFAULT_OPTS = "$FZF_DEFAULT_COLORS --no-multi --layout=reverse --info=inline --no-bold --bind=ctrl-f:half-page-down --bind=ctrl-b:half-page-up";
          };

          programs.git = {
            enable = true;
            userName = "Paul Nodet";
            userEmail = "paul.nodet@gmail.com";

            signing = {
              key = "/Users/pnodet/.ssh/id_rsa";
              signByDefault = true;
            };

            extraConfig = {
              init.defaultBranch = "main";
              core = {
                editor = "nvim";
                pager = "delta";
                excludesfile = "~/.gitignore";
                attributesfile = "~/.gitattributes";
                trustctime = false;
                untrackedCache = true;
                precomposeunicode = false;
                whitespace = "-trailing-space";
              };
              
              lfs.enable = true;
              
              ignores = [
                
              ]

              # Push/Pull settings
              push = {
                default = "simple";
                followTags = true;
                autoSetupRemote = true;
              };

              pull = {
                rebase = false;
              };

              # Branch settings
              branch.sort = "-committerdate";

              # Merge settings
              merge = {
                log = true;
                conflictstyle = "diff3";
                summary = true;
                verbosity = 1;
              };

              # Rebase settings
              rebase.autoStash = true;

              # Diff settings
              diff = {
                renames = "copies";
                mnemonicPrefix = true;
                wordRegex = ".";
                submodule = "log";
                tool = "nvim";
              };

              # Delta settings
              interactive.diffFilter = "delta --color-only";

              # GPG signing
              commit.gpgsign = true;
              tag.gpgsign = true;
              gpg.format = "ssh";
              "gpg \"ssh\"".allowedSignersFile = "~/.ssh/allowed_signers";

              # Other settings
              help.autocorrect = 1;
              rerere = {
                enabled = true;
                autoUpdate = true;
              };
              fetch = {
                writeCommitGraph = true;
                recurseSubmodules = "on-demand";
              };

              # URL rewriting
              "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";

              # Color settings
              color.ui = "auto";
            };

            delta = {
              enable = true;
              options = {
                features = "side-by-side line-numbers decorations";
                whitespace-error-style = "22 reverse";
                decorations = {
                  commit-decoration-style = "bold yellow box ul";
                  file-style = "bold yellow ul";
                  file-decoration-style = "none";
                };
              };
            };

            aliases = {
              # Main branch detection
              main = "!f() { git remote show origin | awk '/HEAD branch/ {print $NF}'; }; f";

              # Add shortcuts
              a = "add --all";
              ai = "add --interactive";

              # Branch shortcuts
              b = "branch";
              ba = "branch --all";
              bd = "branch --delete";
              bc = "rev-parse --abbrev-ref HEAD";
              bl = "branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";

              # Commit shortcuts
              c = "commit";
              ca = "commit --all";
              cm = "commit --message";
              cam = "commit --all --message";
              amend = "commit --amend --reuse-message=HEAD";

              # Checkout/switch shortcuts
              o = "switch";
              ob = "checkout -b";
              om = "switch main";
              go = "!f() { git checkout -b \"$1\" 2> /dev/null || git checkout \"$1\"; }; f";

              # Status shortcuts
              s = "status -s";
              sb = "status -s -b";

              # Log shortcuts
              l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
              lg = "log --oneline --graph --decorate";

              # Push shortcuts
              ps = "push";
              psf = "push --force-with-lease";
              psu = "push -u";

              # Pull shortcuts
              pl = "pull --recurse-submodules";
              plrb = "pull --rebase";

              # Diff shortcuts
              d = "!\"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat\"";
              dc = "diff --cached";

              # Stash shortcuts
              ss = "stash save";
              sa = "stash apply";
              sp = "stash pop";
              sl = "stash list";
            };
          };

          # SSH configuration
          programs.ssh = {
            enable = true;
            extraConfig = ''
              Host *
                AddKeysToAgent yes
                UseKeychain yes
                IdentityFile ~/.ssh/id_ed25519
            '';
          };

          # Direnv - can work alongside z4h
          programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
          };

          # Shell aliases moved from .zshrc
          home.shellAliases = {
            # Editor shortcuts
            ":e" = "nvim .";
            vi = "nvim";
            vim = "nvim";

            # App shortcuts
            ":z" = "open . -a \"Zed\"";
            ":c" = "open . -a \"Cursor\"";
            co = "open . -a \"Visual Studio Code\"";
            cu = "open . -a \"Cursor\"";

            # Navigation
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";

            # Utilities
            c = "clear";
            path = "echo -e \${PATH//:/\\\\n}";
            reload = "exec zsh";
            gpgfix = "export GPG_TTY=$(tty)";
            oo = "open .";
            speedtest = "bunx fast-cli -u --single-line";
            myip = "ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d\\  -f2";

            # Enhanced commands
            mv = "mv -iv";
            ln = "ln -iv";
            g = "git";
            tree = "tree -a -I .git";

            # Sudo shortcuts
            sudo = "sudo ";
            apt = "sudo apt";
            aptitude = "sudo aptitude";
            pacman = "sudo pacman";
            systemctl = "sudo systemctl";
          };

          # Shell functions moved from .zshrc
          home.file.".zsh_functions".text = ''
            # Create directory and cd into it
            function mcd() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

            # Generate UUID and copy to clipboard
            function uuid() {
              uuidgen | tr -d - | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy && pbpaste && echo
            }

            # Generate password and copy to clipboard
            function gen_password() {
              openssl rand -base64 18 | tr -d '/+=\n' | cut -c 1-24 | tee /dev/tty | pbcopy && pbpaste && echo
            }

            # Docker logs shortcut
            function dlogs() {
              docker logs $1 $2
            }

            # GitHub view current branch
            function ghv() {
              gh repo view --web --branch $(git rev-parse --abbrev-ref HEAD)
            }
          '';

          # Additional CLI tools that complement your z4h setup
          home.packages = with pkgs; [
            # CLI utilities not in system packages
            ripgrep # rg - better grep
            fd # better find
            bat # better cat
            tldr # simplified man pages
            mcfly # shell history search
          ];
        };

      configuration =
        { pkgs, config, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            # Editor
            vim
            neovim

            # Shell & CLI utilities
            eza
            fzf
            htop
            jq
            tree
            wget
            zoxide
            zsh-completions
            hyperfine
            dos2unix
            unzip
            p7zip

            # Git tools
            git-cliff
            git-delta
            git-lfs
            lazygit
            gh

            # Development tools
            cmake
            ninja
            ccache
            automake
            autoconf-archive
            nasm

            # Cloud & Infrastructure
            awscli
            terraform
            terraform-ls
            tflint
            kubernetes
            helm
            k9s
            kind

            # Languages & Runtimes
            deno
            bun
            rustc
            cargo
            python310
            python311
            openjdk17
            openjdk21
            php81
            nodejs
            typescript

            # Package managers
            pipx
            uv
            fnm
            cocoapods
            composer

            # Databases
            postgresql_15
            postgresql_16
            postgresql_17
            redis

            # Network & Security
            gnupg
            pinentry_mac
            tailscale
            ngrep
            inetutils

            # Media & Graphics
            ffmpeg
            exiftool
            yt-dlp

            # Development utilities
            just
            biome
            gofumpt
            swift-format
            swiftformat
            solargraph

            # System utilities
            neofetch
            sshx

            # Specialized tools
            fastlane
            rover
          ];

          homebrew = {
            enable = true;
            casks = [
              "chatgpt"
              "claude"
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
              "the-unarchiver"
              "transmission"
              "vlc"
              "whatsapp@beta"
              "zed"
              "zoom"
            ];

            # onActivation.cleanup = "zap";
            # onActivation.autoUpdate = true;
            # onActivation.upgrade = true;
          };

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          nixpkgs.hostPlatform = "aarch64-darwin";
          nix.settings.experimental-features = "nix-command flakes";
          system.configurationRevision = self.rev or self.dirtyRev or null;
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            # Home Manager configuration
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = homeConfiguration;
            };

            nix-homebrew = {
              inherit user;
              enable = true;
              enableRosetta = true;
              mutableTaps = false;
              autoMigrate = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
            };
          }
        ];
      };
    };
}
