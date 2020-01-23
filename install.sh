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
yay -S ttf-droid ttf-iosevka ttf-font-awesome
git clone https://github.com/powerline/fonts.git
cd fonts
./install
cd ..
rm -rf fonts
sudo grub-mkfont -s 36 -o /boot/grub/fonts/droid.pf2 /usr/share/fonts/droid/DroidSansMono.ttf
echo "GRUB_FONT=/boot/grub/fonts/droid.pf2" | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# audio
yay -S pulseaudio pamixer

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

# passwords
yay -S lastpass-cli gnome-keyring

# browsers
yay -S google-chrome firefox

# shell
yay -S zsh antibody alacritty

# chat
yay -S slack-desktop zoom discord

# dev
yay -S jq go jdk-openjdk intellij-idea-ultimate-edition keybase docker docker-compose linux-aufs virtualbox virtualbox-host-modules-arch vagrant xclip
sudo systemctl enable docker
sudo systemctl start docker
sudo gpasswd -a tkellen docker

# configure network
echo devbox | sudo tee /etc/hostname
echo "127.0.0.1 localhost
::1 localhost
127.0.0.1 devbox.localdomain devbox" | sudo tee /etc/hosts

yay -S networkmanager resolvconf openconnet
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable wpa_supplicants
sudo gpasswd -a tkellen network
yay -R dhcpcd

# sdks
wget https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz
tar xvzf openjdk*.tar.gz
rm openjdk-12.0.2_linux-x64_bin.tar.gz
sudo mv jdk-12.0.2 /opt

# two finger click is right click on touchpad
yay -S xf86-input-libinput
sed -i '/Identifier "libinput touchpad catchall"/a Option "ClickMethod" "clickfinger"' /usr/share/X11/xorg.conf.d/40-libinput.conf

# handle power button
yay -S python-pip clearine
grep -qxF 'HandlePowerKey=ignore' /etc/systemd/logind.conf || echo 'HandlePowerKey=ignore' | sudo tee -a /etc/systemd/logind.conf

# window manager
yay -S i3-wm i3blocks rofi
curl https://live.staticflickr.com/4094/4913311714_edca08c0dd_4k_d.jpg > ~/.config/desktop/fire.jpg
