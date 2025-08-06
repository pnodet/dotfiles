# dotfiles

## Prerequisites

### Install Xcode Command Line Tools

```sh
xcode-select --install
```

### Install Nix

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

# Source the Nix environment to make nix commands available

```sh
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

## Setup

### Clone the repository

```sh
git clone https://github.com/pnodet/dotfiles.git ~/.dotfiles
```

### Apply configuration

For M4 MacBook Pro:

```sh
sudo darwin-rebuild switch ~/.dotfiles#pnodet-mbp-m4
```

For M1 MacBook Pro (home server):

```sh
sudo darwin-rebuild switch ~/.dotfiles#pnodet-mbp-m1
```

## Post-Setup

### Install zsh4humans and setup shell configuration

Install zsh4humans:

```sh
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
```

Symlink the zshrc configuration:

```sh
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
```

Reload your shell:

```sh
exec zsh
```
