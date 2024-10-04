export GDK_SCALE=2
export QT_SCALE_FACTOR=2
#export BROWSER=google-chrome-stable
export XCURSOR_THEME=capitaine-cursors-hidpi
export XCURSOR_SIZE=64

# ensure ssh agent is running and exported
# and also that command line access to values
# stored in the local keyring prompt in the
# desktop
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
dbus-update-activation-environment --systemd DISPLAY

# configure monitor layout
~/.config/i3/layout

# start apps
code &
slack &
redshift -l geoclue2 &
alacritty -t terminal-main &
feh --bg-scale ~/.config/desktop/fire.jpg &

echo "Xcursor.theme: ${XCURSOR_THEME}" > ~/.Xresources
xrdb ~/.Xresources

exec i3
