function fzf_project
    begin
        for d in (z -l | string replace -r '^\S+\s+(.*)$' '$1')
            if test -d "$d"
                echo $d
            end
        end
        fd -uug .git ~ | string replace -r '^(.*)/.git$' '$1'
    end | awk '!x[$0]++' | string replace -r '^'$HOME'/(.*)' '~/$1' | fzf --tiebreak=begin | read -l select

    if not test -z "$select"
        builtin cd (string replace -r '^~' $HOME -- $select)
    end

    commandline -f repaint
end
