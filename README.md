# dotfiles

## Prerequisites

### Install Xcode Command Line Tools

```sh
xcode-select --install
```

### Install Rosetta 2 (Apple Silicon Macs only)

```sh
softwareupdate --install-rosetta --agree-to-license
```

### Install Nix

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

### Enable Nix flakes and nix-command

```sh
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

## Setup

### Clone the repository

```sh
git clone https://github.com/pnodet/dotfiles.git ~/.dotfiles
```

### Bootstrap Nix Darwin (first time only)

For M4 MacBook Pro:

```sh
sudo nix run nix-darwin -- switch --flake ~/.dotfiles#pnodet-mbp-m4
```

For M1 MacBook Pro (home server):

```sh
sudo nix run nix-darwin -- switch --flake ~/.dotfiles#pnodet-mbp-m1
```

### Subsequent updates (after bootstrap)

```sh
# For M4 MacBook Pro
darwin-rebuild switch --flake ~/.dotfiles#pnodet-mbp-m4

# For M1 MacBook Pro
darwin-rebuild switch --flake ~/.dotfiles#pnodet-mbp-m1
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
