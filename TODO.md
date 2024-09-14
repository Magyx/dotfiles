# TODO

* [ ] Setup and configure bootloader (systemd-boot)
* [ ] Setup and configure greeter (greetd)
* [ ] Setup and configure plymouth
* [ ] Setup and configure hyprland and plugins
* [ ] Create and configure desktop environment

  * [ ] Create widgets/modules
    * [ ] App launcher
    * [ ] Bar
    * [ ] ...
  * [ ] Theme?
* [ ] Setup and configure Syncthing
* [ ] Windows 11 passthrough

  * [ ] Install script

### Packages to look through:

- Desktop-Base + Common packages
  - GPU drivers
    - xf86-video-amdgpu
    - xf86-video-ati
  - Network
    - b43-fwcutter
    - broadcom-wl-dkms
    - dnsmasq
    - dnsutils
    - ethtool
    - iwd
    - modemmanager
    - networkmanager
    - networkmanager-openconnect
    - networkmanager-openvpn
    - nss-mdns
    - openssh
    - usb_modeswitch
    - wpa_supplicant
    - xl2tpd
  - Package management
    - downgrade
    - pacman-contrib
    - pkgfile
    - rebuild-detector
    - reflector
    - yay
  - Desktop integration
    - accountsservice
    - bash-completion
    - bluez
    - bluez-utils
    - ffmpegthumbnailer
    - gst-libav
    - gst-plugin-pipewire
    - gst-plugins-bad
    - gst-plugins-ugly
    - libdvdcss
    - libgsf
    - libopenraw
    - mlocate
    - poppler-glib
    - xdg-user-dirs
    - xdg-utils
  - Filesystem
    - efitools
    - haveged
    - nfs-utils
    - ntp
    - smartmontools
    - unrar
    - unzip
    - xz
  - Fonts
    - freetype2
    - noto-fonts
    - noto-fonts-emoji
    - noto-fonts-cjk
    - noto-fonts-extra
  - Audio
    - alsa-firware
    - alsa-plugins
    - alsa-utils
    - pavucontrol
    - pipewire-pulse
    - wireplumber
    - pipewire-alsa
    - pipewire-jack
    - rtkit
  - Hardware
    - dmidecode
    - dmraid
    - hdparm
    - hwdetect
    - lsscsi
    - mtools
    - sg3_utils
    - sof-firmware
  - Power
    - power-profiles-daemon
    - upower
  - CPU specific microcode update packages
    - amd-ucode
    - intel-ucode
- Recommended applications selection
  - duf
  - findutils
  - fsarchiver
  - git
  - glances
  - hwinfo
  - inxi
  - meld
  - nano-syntax-highlighting
  - pv
  - python-defused
  - python-packaging
  - rsync
  - tldr
  - sed
  - vi
  - wget
- Firefox and language package
  - firefox
  - firefox-i18n-$LOCALE
- Spell Checker and language package
  - aspell
  - aspell-$LOCALE
