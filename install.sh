#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
PKGS="$DOTFILES/packages.list"
AUR_PKGS="$DOTFILES/packages-aur.list"

# Install packages
sudo pacman -S --needed - < <(grep -vE '^\s*(#|$)' "$PKGS")

if ! command -v yay >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd "$DOTFILES"
fi

yay -S --needed - < <(grep -vE '^\s*(#|$)' "$AUR_PKGS")

# Pull submodules
git -C "$DOTFILES" submodule update --init --recursive

# Setup user permissions
sudo usermod -aG video,render,storage,wheel "$USER"

# Create dirs
mkdir -p "$HOME/.tmux/"
mkdir -p "$HOME/.config/"

# Symlinks
ln -sf "$DOTFILES/home/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/home/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/home/.icons" "$HOME/.icons"
ln -sf "$DOTFILES/.tmux/plugins" "$HOME/.tmux/plugins"
ln -sf "$DOTFILES/.config/foot" "$HOME/.config/foot"
ln -sf "$DOTFILES/.config/fontconfig" "$HOME/.config/fontconfig"
ln -sf "$DOTFILES/.config/environment.d" "$HOME/.config/environment.d"
ln -sf "$DOTFILES/.config/niri" "$HOME/.config/niri"
ln -sf "$DOTFILES/.config/mako" "$HOME/.config/mako"
ln -sf "$DOTFILES/.config/orbit" "$HOME/.config/orbit"
ln -sf "$DOTFILES/.config/sunsetr" "$HOME/.config/sunsetr"
ln -sf "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/.config/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"
ln -sf "$DOTFILES/.config/hypr" "$HOME/.config/hypr"
ln -sf "$DOTFILES/.config/input-remapper-2" "$HOME/.config/input-remapper-2"
ln -sf "$DOTFILES/.config/solaar" "$HOME/.config/solaar"

# System-level symlinks
sudo mkdir -p /etc/pacman.d/hooks
if [ -d "$DOTFILES/etc/pacman.d/hooks" ]; then
  sudo ln -sf "$DOTFILES/etc/pacman.d/hooks/"* /etc/pacman.d/hooks/
fi

sudo mkdir -p /etc/modprobe.d
if [ -d "$DOTFILES/etc/modprobe.d" ]; then
  sudo ln -sf "$DOTFILES/etc/modprobe.d/"* /etc/modprobe.d/
fi

# Services
mkdir -p "$HOME/.config/systemd/user/"
if command -v foot >/dev/null 2>&1; then
  mkdir -p "$HOME/.config/systemd/user/foot-server.service.d"
  mkdir -p "$HOME/.config/systemd/user/niri.service.wants"
  ln -sf "$DOTFILES/.config/systemd/user/foot-server.service.d/niri.conf" "$HOME/.config/systemd/user/foot-server.service.d/niri.conf"
  ln -sf "/usr/lib/systemd/user/foot-server.socket" "$HOME/.config/systemd/user/niri.service.wants/foot-server.socket"
  systemctl --user enable --now foot-server.socket
fi
ln -sf "$DOTFILES/.config/systemd/user/orbitd.service" "$HOME/.config/systemd/user/orbitd.service"

# Specific configs
ln -sf "$DOTFILES/.tmux/.tmux-which-key.yaml" "$HOME/.tmux/plugins/tmux-which-key/config.yaml"
