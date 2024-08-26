yay -Syyu

yay -S timeshift
timeshift --btrfs
sudo timeshift --create --comments 'Minimal arch'

yay -S --needed \
  speech-dispatcher

# Hyprland Apps
yay -S --needed \
  alacritty \
  nautilus \
  gvfs-smb \
  playerctl \
  btop \
  gnome-control-center \
  aylurs-gtk-shell

# Theme
yay -S --needed \
  gnome-themes-extra \
  adwaita-qt5-git \
  adwaita-qt6-git \
  bibata-cursor-theme-bin

yay -S --needed \
  ttf-hack-nerd

# Hyprland
yay -S --needed \
  hyprland-git \
  xdg-desktop-portal-hyprland \
  qt6-wayland \
  qt5-wayland \
  xorg-xhost \
  polkit-kde-agent

