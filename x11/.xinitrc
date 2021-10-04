#!/bin/bash
# https://vincent.bernat.ch/en/blog/2018-4k-hidpi-dual-screen-linux
# dpi=$(xdpyinfo|grep resolution|awk '{print $2}'|cut -d"x" -f1);
case "$(hostname)" in
    desktop|nzxt)
        dpi=168
        ;;
    x1yoga|laptop)
        dpi=192
        ;;
esac
# For applications supporting XSettings, `Xft/DPI' sets font scaling
# (and sometimes interface scaling), `Gdk/WindowScalingFactor' sets
# interface scaling with GTK 3, and `Gdk/UnscaledDPI' undo font scaling
# for GTK 3 applications.
> ~/.xsettingsd cat <<EOF
# dpi is $dpi
Xft/DPI $(( $dpi*1024 ))
Gdk/WindowScalingFactor $(( $dpi/96 ))
Gdk/UnscaledDPI $(( $dpi*1024/($dpi/96) ))
Xft/Hinting 1
Xft/HintStyle "hintslight"
Xft/Antialias 1
Xft/RGBA "rgb"
Gtk/FontName "Sans 9"
Net/ThemeName "Arc"
Gtk/DecorationLayout "menu:"
Gtk/KeyThemeName "Emacs"
Gtk/CursorThemeName "whiteglass"
Gtk/CursorThemeSize 36
EOF
pkill -HUP xsettingsd || xsettingsd &
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=1
xrdb ~/.Xresources
echo Xft.dpi: $dpi | xrdb -merge
# https://github.com/piroor/treestyletab/issues/2969#issuecomment-892480583
# for firefox css
export GTK_THEME="Arc"

case "$(hostname)" in
    x201t)
        export LIBGL_ALWAYS_SOFTWARE=1
        # for alacritty
        export WINIT_UNIX_BACKEND=x11 # alacritty wayland crash temp fix
        export WINIT_X11_SCALE_FACTOR=$(awk "BEGIN{print $dpi/96}")
        ;;
esac

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_DATA_HOME=$HOME/.local/share
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
eval $(dbus-launch --exit-with-session --sh-syntax)

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

case "$(hostname)" in
    desktop)
# xrandr --output DP-0 --rotate normal --auto --left-of DP-2 --output DP-2 --rotate normal --auto &
#        xrandr --output DP-2 --rotate normal --output DP-0 --off
        ;;
    x1yoga)
        # otherwise gesture not recognized by firefox etc
        xinput set-prop 'Wacom Pen and multitouch sensor Finger touch' 'Wacom Enable Touch Gesture' 0
        autorotate &
        ;;
    laptop)
        xrandr --setprovideroutputsource modesetting NVIDIA-0
        xrandr --output eDP-1-1 --auto --primary --output DP-1 --auto --left-of eDP-1-1
        # xrandr --output eDP-1 --auto --primary --output DP-1-1 --auto --left-of eDP-1
        # autorotate left
        ;;
esac

# cursor
xsetroot -cursor_name left_ptr
unclutter &

# input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export QT5_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx5 &

exec bspwm
