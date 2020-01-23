export GDK_SCALE=2
export QT_SCALE_FACTOR=2
export BROWSER=google-chrome-stable
eval $(ssh-agent)

JAVA_HOME=/usr/lib/jvm/java-13-openjdk intellij-idea-ultimate-edition &
termite -t termite-persist &
slack &
discord &
redshift -l geoclue2 &
zoom &
feh --bg-scale ~/.config/desktop/fire.jpg &

exec i3