export GDK_SCALE=2
export QT_SCALE_FACTOR=2
eval $(ssh-agent)

termite -e tmux &
JAVA_HOME=/usr/lib/jvm/java-13-openjdk intellij-idea-ultimate-edition &
GDK_SCALE=3 firefox &
slack --disable-gpu &
discord --disable-gpu &
redshift -l geoclue2 &
nitrogen --restore &
zoom &
feh --bg-scale ~/.config/desktop/fire.jpg &

# running on just a laptop
if [[ ${WORKING_MODE} == "small" ]]; then
  :
fi

# running with desktop dual monitors
if [[ ${WORKING_MODE} == "big" ]]; then
  xrandr --output eDP1 --off \
    --output DP3 --mode 3840x2160 --pos 3840x0 --rotate normal \
    --output DP4-2 --mode 3840x2160 --pos 0x0  --rotate normal
fi

exec i3

