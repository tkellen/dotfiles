export GDK_SCALE=2
export QT_SCALE_FACTOR=2
eval $(ssh-agent)

termite &
JAVA_HOME=/usr/lib/jvm/java-13-openjdk intellij-idea-ultimate-edition &
slack --disable-gpu &
discord --disable-gpu &
redshift -l geoclue2 &
zoom &
feh --bg-scale ~/.config/desktop/fire.jpg &

# running on just a laptop
if [[ ${WORKING_MODE} == "small" ]]; then
  GDK_SCALE=3 firefox &
fi

# running with desktop dual monitors
if [[ ${WORKING_MODE} == "big" ]]; then
  firefox &
  xrandr --output eDP1 --off \
    --output DP3 --mode 3840x2160 --pos 0x0 --rotate normal --primary \
    --output DP4-2 --mode 3840x2160 --pos 3840x0  --rotate normal
fi

exec i3

