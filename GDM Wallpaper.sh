#!/bin/sh
wallpaperlocation=`gsettings get org.gnome.desktop.background picture-uri`
wallpaperlocation="$(echo $wallpaperlocation | sed 's/file:\/\///g')"
wallpaperlocation="$(echo $wallpaperlocation | sed 's/\x27//g')"
workdir=${HOME}/shell-theme
gst=/usr/share/gnome-shell/gnome-shell-theme.gresource

for r in `gresource list $gst`; do
	r=${r#\/org\/gnome\/shell/}
	if [ ! -d $workdir/${r%/*} ]; then
	  mkdir -p $workdir/${r%/*}
	fi
done

for r in `gresource list $gst`; do
        gresource extract $gst $r >$workdir/${r#\/org\/gnome\/shell/}
done

cp $wallpaperlocation ${HOME}/shell-theme/theme/login-background

convert ${HOME}/shell-theme/theme/login-background -blur 64x8 ${HOME}/shell-theme/theme/login-background

cat <<EOM >${HOME}/shell-theme/theme/gnome-shell-theme.gresource.xml
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>calendar-today.svg</file>
    <file>checkbox-focused.svg</file>
    <file>checkbox-off-focused.svg</file>
    <file>checkbox-off.svg</file>
    <file>checkbox.svg</file>
    <file>gnome-shell.css</file>
    <file>gnome-shell-high-contrast.css</file>
    <file>icons/message-indicator-symbolic.svg</file>
    <file>no-events.svg</file>
    <file>no-notifications.svg</file>
    <file>pad-osd.css</file>
    <file>icons/eye-open-negative-filled-symbolic.svg</file>
    <file>icons/eye-not-looking-symbolic.svg</file>
    <file>icons/pointer-double-click-symbolic.svg</file>
    <file>icons/pointer-drag-symbolic.svg</file>
    <file>icons/pointer-primary-click-symbolic.svg</file>
    <file>icons/pointer-secondary-click-symbolic.svg</file>
    <file>icons/keyboard-caps-lock-filled-symbolic.svg</file>
    <file>icons/keyboard-enter-symbolic.svg</file>
    <file>icons/keyboard-hide-symbolic.svg</file>
    <file>icons/keyboard-layout-filled-symbolic.svg</file>
    <file>icons/keyboard-shift-filled-symbolic.svg</file>
    <file>process-working.svg</file>
    <file>toggle-off.svg</file>
    <file>toggle-on.svg</file>
    <file>toggle-off-dark.svg</file>
    <file>toggle-on-dark.svg</file>
    <file>login-background</file>
  </gresource>
</gresources> 
EOM

cat <<EOM >>${HOME}/shell-theme/theme/gnome-shell.css
#lockDialogGroup {
  background: #2e3436 url("login-background");
  background-size: 1366px 768px;
  background-repeat: no-repeat;
}
EOM
cd ${HOME}/shell-theme/theme/

glib-compile-resources gnome-shell-theme.gresource.xml

pkexec cp ${HOME}/shell-theme/theme/gnome-shell-theme.gresource /usr/share/gnome-shell/

rm -r ${HOME}/shell-theme
