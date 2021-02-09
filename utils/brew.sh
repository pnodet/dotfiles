#!/bin/sh

if test ! "$(command -v brew)"; then
  echo 'Installing Homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  sudo chown -R $(whoami) $(brew --prefix)/*
  sudo chown -R $(whoami) .config
  sudo chown -R $(whoami) .gitconfig
fi
brew -v
brew analytics off

# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

linuxify_check_dirs() {
  result=0

  for dir in /usr/local/bin /usr/local/sbin; do
    if [[ ! -d $dir || ! -w $dir ]]; then
      echo "$dir must exist and be writeable"
      result=1
    fi
  done

  return $result
}

set -euo pipefail
linuxify_check_dirs

##############################################################################################################

tap_formulas=(
  "homebrew/cask-fonts"
  "homebrew/cask-versions"
  "bramstein/webfonttools"
  "ldez/tap"
)

# Install tap
for ((i = 0; i < ${#tap_formulas[@]}; i++)); do
  if ! brew ls --versions ${tap_formulas[i]} >/dev/null; then
    brew tap ${tap_formulas[i]}
  fi
done

##############################################################################################################

function require_brew() {
  echo "brew $1 $2"
  brew list $1 >/dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo "brew install $1 $2"
    brew install $1 $2
    if [[ $? != 0 ]]; then
      echo "failed to install $1! aborting..."
      # exit -1
    fi
  fi
  echo "done"
}

declare -a linuxify_formulas=(

  # GNU programs non-existing in macOS
  "watch"
  "wget"
  "wdiff"
  "gdb"
  "autoconf"

  # GNU programs whose BSD counterpart is installed in macOS
  "coreutils"
  "binutils"
  "diffutils"
  "ed"
  "findutils"
  "gawk"
  "gnu-indent"
  "gnu-sed"
  "gnu-tar"
  "gnu-which"
  "grep"
  "gzip"
  "screen"

  # GNU programs existing in macOS which are outdated
  "bash"
  "emacs"
  "gpatch"
  "less"
  "m4"
  "make"
  "nano"
  "bison"

  # BSD programs existing in macOS which are outdated
  "flex"

  # Other common/preferred programs in GNU/Linux distributions
  "libressl"
  "file-formula"
  "git"
  "openssh"
  "perl"
  "python"
  "rsync"
  "unzip"
  "vim"
)

# Install all formulas
for ((i = 0; i < ${#linuxify_formulas[@]}; i++)); do
  require_brew ${linuxify_formulas[i]}
done

##############################################################################################################

declare -a brew_formulas=(
  #'ack'                 # Search tool like grep, but optimized for programmers
  'bat'                  # Clone of cat(1) with syntax highlighting and Git integration
  'brew-cask-completion' # A Dependency Manager for PHP
  'composer'             # A Dependency Manager for PHP
  'dos2unix'             # Convert text between DOS, UNIX, and Mac formats
  'direnv'               # Load/unload environment variables based on $PWD
  'fzf'                  # Command-line fuzzy finder written in Go
  'ffmpeg'               # Play, record, convert, and stream audio and video
  'jq'                   # Lightweight and flexible command-line JSON processor
  'gnu-getopt'           # Command-line option parsing utility
  'gnutls'               # GNU Transport Layer Security (TLS) Library
  'git-lfs'              # An open source Git extension for versioning large files
  'gist'                 # Potentially the best command line gister.
  'golang'               # Open source programming language to build simple, reliable, and efficient software
  'gmp'                  # GNU multiple precision arithmetic library
  'grc'                  # Colorize logfiles and command output
  'htop'                 # Improved top (interactive process viewer)
  'hugo'                 # Configurable static site generator
  'libpng'               # Library for manipulating PNG images
  'libtiff'              # Library for manipulating TIFF images
  'm-cli'                # Swiss Army Knife for macOS
  'macosvpn'             # Create Mac OS VPNs programmatically
  'mas'                  # Mac App Store command-line interface
  'minisign'             # Sign files & verify signatures. Works with signify in OpenBSD
  'mtr'                  # 'traceroute' and 'ping' in a single tool
  'moreutils'            # Collection of tools that nobody wrote when UNIX was young
  'navi'                 # Interactive cheatsheet tool for the command-line
  'node'                 # Platform built on V8 to build network applications
  'nmap'                 # Port scanning utility for large networks
  'youtube-dl'           # Download YouTube videos from the command-line
  'openssl'              # Cryptography and SSL/TLS Toolkit
  'ruby'                 # Powerful, clean, object-oriented scripting language
  'readline'             # Library for command-line editing
  'neofetch'             # Generate ASCII art with terminal, shell, and OS info
  'tldr'                 # Simplified and community-driven man pages
  'tree'                 # Display directories as trees (with optional color/HTML output)
  'ag'                   # Code-search similar to ack
  'wifi-password'        # Show the current WiFi network password
  'pkg-config'           # Manage compile and link flags for libraries
  'neovim'
  'colordiff'
  'php' # General-purpose scripting language
  #brew services start php #to start automatically
  'gnupg' # same as brew install gpg
  #sudo brew services start unbound #to start automatically
  #'sbt'                  # Build tool for Scala projects
  #'gradle' # Open-source build automation tool based on the Groovy and Kotlin DSL
  #'ant'    # Android Dev Tools
  #'maven'  # Android Dev Tools
  #'gradle' # Android Dev Tools
  #'pbzip2'              # Data Compression Software
  #'zsh'                 # UNIX shell (command interpreter)
  #'postgresql' # Object-relational database system
  #brew services start postgresql #to start automatically
)

for app in "${brew_formulas[@]}"; do
  require_brew "$app"
done

##############################################################################################################

# gdb requires special privileges to access Mach ports.
# One can either codesign the binary as per https://sourceware.org/gdb/wiki/BuildingOnDarwin
# Or, on 10.12 Sierra or later with SIP, declare `set startup-with-shell off` in `~/.gdbinit`:
grep -qF 'set startup-with-shell off' ~/.gdbinit || echo 'set startup-with-shell off' | tee -a ~/.gdbinit >/dev/null

# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 "$mtrlocation"/sbin/mtr
sudo chown root "$mtrlocation"/sbin/mtr

LANG=en_EN git lfs install #otherwise might cuz trouble see : https://github.com/git-lfs/git-lfs/issues/2837
