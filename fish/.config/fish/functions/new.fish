function new
    argparse 'x/no_open' 'n/name=?' -- $argv
    or return
    set -l lang $argv[1]
    set -l workspace $HOME/workspace
    set -l dir

    if test -z "$_flag_name"
        set _flag_name "scratch"
    end
    for d in $_flag_name $_flag_name(seq 1 9)
        if test ! -d $workspace/$d
            set dir $d
            break
        end
    end
    if test -z "$dir"
        echo no available dir
        return 1
    end
    echo dir is $dir

    switch $lang
        case rust
            cd ~/workspace
            cargo new $dir
            cd $dir
            if test -z "$_flag_no_open"
                edit src/main.rs
            end
        case cpp
            echo cpp
        case '*'
            echo unknown
            cd ~/workspace
            mkdir $dir
            cd $dir
    end
end
