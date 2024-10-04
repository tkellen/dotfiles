#!/bin/bash
BASE_PATH="$(cd "$(dirname "$0")"; pwd -P)"
SCRIPT_FILE=$(basename "${BASH_SOURCE[0]}")

# install dotfiles
rsync -avzP --exclude .git --exclude .idea ${BASE_PATH}/.[^.]* ~/
# allow easy reconfiguration of this file by running "reup"
printf "\nfunction reup {\n  ${BASE_PATH}/${SCRIPT_FILE}\n  source ~/.zshrc\n}" >> ~/.zshrc
# reconfigure running openbox with latest config

# give a chance to bail out if we aren't doing an initial setup
read -p "run bootstrap [y/n]: " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi
echo

# configure time
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
sudo hwclock --systohc

# configure locale
sudo sed -i '/^.en_US/s/^#//g' /etc/locale.gen
sudo locale-gen
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf

# configure package manager
(
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ..
  sudo rm -rf yay
)

# utils
yay -S curl wget

# fonts
yay -S ttf-droid ttf-iosevka ttf-font-awesome noto-fonts-emoji
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts
sudo grub-mkfont -s 36 -o /boot/grub/fonts/droid.pf2 /usr/share/fonts/droid/DroidSansMono.ttf
echo "GRUB_FONT=/boot/grub/fonts/droid.pf2" | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# audio
yay -S pipewire wireplumber pamixer

# video
yay -S vulkan-intel

# screen brightness
yay -S acpilight
sudo gpasswd -a tkellen video
# /etc/systemd/system/backlight.service is owned by video group

# color temperature following day/night
yay -S redshift

# power management for lid close/open/power
yay -S acpid
sudo systemctl enable acpid
sudo systemctl start acpid
# TODO: configure /etc/acpi/handler.sh
# browsers
yay -S google-chrome-stable firefox

xdg-mime default google-chrome-stable.desktop x-scheme-handler/http
xdg-mime default google-chrome=stable.desktop x-scheme-handler/https
xdg-mime default google-chrome-stable.desktop text/http

# shell
yay -S zsh starship alacritty

# chat
yay -S slack-desktop zoom discord

# password storage
yay -S lastpass-cli gnome-keyring seahorse

# dev
yay -S jq go code-git keybase docker docker-compose linux-aufs virtualbox virtualbox-host-modules-arch vagrant xclip rust
cargo install tock
sudo systemctl enable docker
sudo systemctl start docker
sudo gpasswd -a tkellen docker

# configure network
echo devbox | sudo tee /etc/hostname
echo "127.0.0.1 localhost
::1 localhost
127.0.0.1 devbox.localdomain devbox" | sudo tee /etc/hosts

yay -S wpa_supplicant iwlwifi networkmanager resolvconf openconnect
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable wpa_supplicant
sudo gpasswd -a tkellen network
yay -R dhcpcd

# two finger click is right click on touchpad
yay -S xf86-input-libinput
sudo sed -i '/Identifier "libinput touchpad catchall"/a Option "ClickMethod" "clickfinger"' /usr/share/X11/xorg.conf.d/40-libinput.conf

# handle touchscreen
yay -S xorg-xinput

# wifi tools
yay -S aircrack-ng hashcat hcxtools intel-opencl-runtime

# handle power button
yay -S python-pip clearine
grep -qxF 'HandlePowerKey=ignore' /etc/systemd/logind.conf || echo 'HandlePowerKey=ignore' | sudo tee -a /etc/systemd/logind.conf

# window manager
yay -S xorg-xinit xorg-xserver i3-gaps i3blocks rofi feh
mkdir -p ~/.config/desktop
curl https://live.staticflickr.com/4094/4913311714_edca08c0dd_4k_d.jpg > ~/.config/desktop/fire.jpg

# neato cursors
yay -S capitaine-cursors-hidpi
