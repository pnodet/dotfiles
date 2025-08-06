# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix-based dotfiles repository for macOS that uses:

- **Nix Darwin**: macOS system configuration management
- **Home Manager**: User environment and dotfiles management
- **nix-homebrew**: Homebrew integration with Nix
- **nix-casks**: Additional macOS application management

The entire system configuration is declaratively managed through a single `flake.nix` file.

## Build and Deployment Commands

### Prerequisites

```bash
# Install Xcode Command Line Tools (required)
xcode-select --install

# Install Rosetta 2 (required for Apple Silicon Macs)
softwareupdate --install-rosetta --agree-to-license
```

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/pnodet/dotfiles.git ~/.dotfiles

# Install Nix (if not already installed)
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# Enable flakes and nix-command system-wide
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# Bootstrap Nix Darwin (first time only - choose appropriate machine)
sudo nix run nix-darwin -- switch --flake ~/.dotfiles#pnodet-mbp-m4    # M4 MacBook Pro
sudo nix run nix-darwin -- switch --flake ~/.dotfiles#pnodet-mbp-m1    # M1 MacBook Pro
```

### Post-Setup

```bash
# Install zsh4humans and setup shell configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
exec zsh
```

### System Management

```bash
# Build and apply system configuration
# For M4 MacBook Pro:
darwin-rebuild build --flake .#pnodet-mbp-m4
darwin-rebuild switch --flake .#pnodet-mbp-m4

# For M1 MacBook Pro (home server):
darwin-rebuild build --flake .#pnodet-mbp-m1
darwin-rebuild switch --flake .#pnodet-mbp-m1

# Check what will be built/changed
darwin-rebuild build --flake .#pnodet-mbp-m4 --show-trace
darwin-rebuild build --flake .#pnodet-mbp-m1 --show-trace

# View changelog for breaking changes
darwin-rebuild changelog
```

### Package Management

```bash
# Update flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Search for packages
nix search nixpkgs <package-name>

# Test packages temporarily
nix shell nixpkgs#<package-name>
```

### Troubleshooting Commands

```bash
# Rebuild with verbose output
darwin-rebuild switch --flake .#pnodet-mbp-m4 --show-trace --verbose
darwin-rebuild switch --flake .#pnodet-mbp-m1 --show-trace --verbose

# Check flake evaluation
nix flake check

# Garbage collect old generations
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Architecture

### Core Structure

- **`flake.nix`**: Single source of truth containing:
  - System configuration (nix-darwin)
  - User environment (home-manager)
  - Package management (nixpkgs + homebrew)
  - Application preferences and settings
  - Multi-machine support

### Machine Configurations

```nix
user = {
  name = "pnodet";
  fullName = "Paul Nodet";
};

machines = {
  "pnodet-mbp-m4" = {};  # M4 MacBook Pro (daily use)
  "pnodet-mbp-m1" = {};  # M1 MacBook Pro (home server)
};
```

The flake supports multiple machine configurations with the same base setup. Currently both machines use identical configurations, but this structure allows for machine-specific customizations in the future.

### Key Configuration Sections

- **System Packages**: Core utilities, development tools, CLI replacements
- **Homebrew Integration**: macOS-specific apps, Mac App Store apps, CLI tools
- **User Applications**: GUI applications via nix-casks
- **System Preferences**: macOS defaults, dock, finder, trackpad settings
- **Development Environment**: Git, SSH, Zed editor, terminal (Ghostty)

### Package Categories

**Development Tools**:

- Languages: Go, Rust, Node.js (fnm), Python (uv), Ruby, PHP, Zig
- Build tools: CMake, Ninja, Just, Meson
- Version control: Git with Delta pager, Lazygit, GitHub CLI

**CLI Utilities** (modern replacements):

- `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep)
- `bottom` (htop), `dust` (du), `zoxide` (cd)

**Applications** (nix-casks):

- Editors: Cursor, Zed
- Communication: Discord, Signal, Slack, WhatsApp
- Development: Figma, Linear, Notion, Obsidian
- System: Stats, AlDente, Little Snitch

### Configuration Management

- **System settings**: Managed via `targets.darwin.defaults`
- **Application preferences**: Declaratively configured in Home Manager
- **SSH hosts**: Predefined connections with proper key management
- **Git configuration**: Comprehensive setup with modern workflows

## Development Workflow

### Making Changes

1. Edit `flake.nix` for system/package changes
2. Test with `darwin-rebuild build --flake .#<hostname>`
   - M4: `darwin-rebuild build --flake .#pnodet-mbp-m4`
   - M1: `darwin-rebuild build --flake .#pnodet-mbp-m1`
3. Apply with `darwin-rebuild switch --flake .#<hostname>`
4. Commit changes to version control

### Adding New Applications

- **CLI tools**: Add to `environment.systemPackages` or `home.packages`
- **GUI apps**: Add to nix-casks packages or homebrew casks
- **Mac App Store**: Add to `homebrew.masApps` with app ID

### Configuration Philosophy

- Declarative: All system state defined in code
- Reproducible: Same configuration produces same system
- Version controlled: All changes tracked in Git
- Rollback capable: Easy to revert to previous states

## Package Management Architecture

### Nix Flake Structure

The `flake.nix` is organized into distinct sections:

**Inputs**: External dependencies and channel versions

- `nixpkgs`: Main package repository (pinned to 25.05-darwin)
- `nix-darwin`: macOS system configuration framework
- `home-manager`: User environment management
- `nix-homebrew`: Homebrew integration with deterministic taps
- `nix-casks`: Additional macOS applications via Nix

**Package Categories**:

- **System Packages** (`environment.systemPackages`): Core utilities accessible system-wide
- **User Packages** (`home.packages`): Development tools and CLI utilities
- **Homebrew Integration**: macOS-specific applications and Mac App Store apps
- **Nix-Casks**: GUI applications managed through Nix

### Multi-Machine Configuration

Uses a single flake with machine-specific outputs:

```nix
machines = {
  "pnodet-mbp-m4" = {};  # M4 MacBook Pro (daily use)
  "pnodet-mbp-m1" = {};  # M1 MacBook Pro (home server)
};
```

Both machines currently use identical configurations but the structure supports divergent customization.

## Development Tools Integration

### Language Environments

- **Node.js**: Managed via `fnm` (Fast Node Manager) for version switching
- **Python**: Uses `uv` for ultra-fast package management and `pipx` for isolated applications
- **Rust**: Managed through `rustup` toolchain installer
- **Go**: Direct package installation with standard tooling
- **Other Languages**: Ruby, PHP, Zig, Deno, Bun support

### Modern CLI Replacements

The system provides modern alternatives to standard Unix tools:

- `eza` replaces `ls` with enhanced directory listing
- `bat` replaces `cat` with syntax highlighting
- `ripgrep` replaces `grep` with faster search
- `fd` replaces `find` with simpler syntax
- `bottom` replaces `htop` with better system monitoring
- `zoxide` replaces `cd` with smart directory jumping

### Build Systems and Development

- **Build Tools**: CMake, Ninja, Just, Meson for various project types
- **Version Control**: Git with Delta pager, Lazygit for terminal UI, GitHub CLI
- **Infrastructure**: kubectl, AWS CLI v2, Google Cloud SDK, Terraform, k9s
- **Containers**: OrbStack for Docker/Linux, Kind for local Kubernetes

## System Preferences Management

### macOS Defaults Configuration

System behavior is controlled via `targets.darwin.defaults`:

- **Dock**: Left orientation, auto-hide, custom hot corners
- **Finder**: Show hidden files, extensions, path bar
- **Trackpad**: Tap to click enabled
- **Security**: Touch ID for sudo, password required immediately after sleep
- **Networking**: Cloudflare DNS (1.1.1.1, 1.0.0.1)

### Application Preferences

Many application settings are declaratively managed:

- Default applications for file types (JSON → Zed, torrents → Transmission)
- Safari developer tools and privacy settings
- Screenshot location and format preferences
- Keyboard shortcuts and system hotkeys configuration
