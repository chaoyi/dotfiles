# monitor [single/dual] landscape
# monitor dual landscape
# monitor dual portrait

function monitor
    set -l counts $argv[1]
    set -l orientation $argv[2]
    if test -z "$counts"
        set counts single
    end
    if test -z "$orientation"
        set orientation landscape
    end
    set -l monitor1
    set -l monitor2

    switch $hostname
        case laptop
            set monitor1 eDP-1-1
            set monitor2 DP-1
        case dekstop
            set monitor1 DP-2
            set monitor2 DP-0
    end

    switch "$counts $orientation"
        case "dual landscape"
            xrandr --output $monitor1 --auto --primary --output $monitor2 --auto --left-of $monitor1
            autorotate normal
        case "dual portrait"
            xrandr --output $monitor1 --auto --primary --output $monitor2 --auto --left-of $monitor1
            autorotate left
        case "single landscape"
            xrandr --output $monitor1 --auto --primary --output $monitor2 --off
            autorotate normal
        case "single portrait"
            xrandr --output $monitor1 --auto --primary --output $monitor2 --off
            autorotate left
        case "single landscape_main"
            set t $monitor1
            set monitor1 $monitor2
            set monitor2 $t
            xrandr --output $monitor1 --auto --primary --output $monitor2 --off
    end

    switch "$counts"
        case single
            bspc monitor $monitor1 -d "" "" "" "" "" "" "" "" ""
        case dual
            bspc monitor $monitor1 -d "" "" "" "" "" "" "" "" ""
            bspc monitor $monitor2 -d "" "" "" "" "" "" "" "" ""
    end

    ~/.config/polybar/launch.sh
    ~/.fehbg
end
