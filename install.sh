#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
PKGS="$DOTFILES/packages.list"
AUR_PKGS="$DOTFILES/packages-aur.list"
CUSTOM_PKGS="$DOTFILES/packages-custom.list"

# Install packages
echo "Installing packages"
sudo pacman -S --needed - < <(grep -vE '^\s*(#|$)' "$PKGS")

if ! command -v yay >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd "$DOTFILES"
fi

echo "Installing AUR packages"
yay -S --needed - < <(grep -vE '^\s*(#|$)' "$AUR_PKGS")

echo "Installing custom PKGBUILDs"
while IFS= read -r url || [ -n "$url" ]; do
  [[ -z "$url" || "$url" =~ ^\s*# ]] && continue

  echo "Building $url"
  BUILD_TEMP=$(mktemp -d)

  (
    cd "$BUILD_TEMP"
    curl -fsSL "$url" -o PKGBUILD
    # -s: install deps, -i: install package, -r: cleanup deps, --noconfirm: automatic
    makepkg -sir --noconfirm
  )

  rm -rf "$BUILD_TEMP"
done <"$CUSTOM_PKGS"

# Pull submodules
git -C "$DOTFILES" submodule update --init --recursive

# Setup user permissions
sudo usermod -aG video,render,storage,wheel "$USER"

# Symlinks
mkdir -p "$HOME/.tmux/"
mkdir -p "$HOME/.config/"

echo "Creating symlinks"

ln -sf "$DOTFILES/home/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/home/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/home/.icons" "$HOME/.icons"
ln -sf "$DOTFILES/.tmux/plugins" "$HOME/.tmux/plugins"

CONFIG_FILES=("foot" "fontconfig" "environment.d" "niri" "mako" "orbit" "sunsetr" "nvim" "xdg-desktop-portal" "input-remapper-2" "solaar" "gtk-3.0")
for config in "${CONFIG_FILES[@]}"; do
  ln -sf "$DOTFILES/.config/$config" "$HOME/.config/$config"
done

# System-level symlinks
sudo mkdir -p /etc/pacman.d/hooks
if [ -d "$DOTFILES/etc/pacman.d/hooks" ]; then
  sudo ln -sf "$DOTFILES/etc/pacman.d/hooks/"* /etc/pacman.d/hooks/
fi

# System-level syncing
# These need to be copies as initramfs sits before mounting /home.
# Any changes need to be met by rerunning this part.
echo "Syncing system level configurations"
sudo mkdir -p /etc/modprobe.d
if [ -d "$DOTFILES/etc/modprobe.d" ]; then
  sudo rm -f /etc/modprobe.d/*
  sudo cp -a "$DOTFILES/etc/modprobe.d/"* /etc/modprobe.d/

  sudo mkinitcpio -P
fi

# Services
echo "Installing services"
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
