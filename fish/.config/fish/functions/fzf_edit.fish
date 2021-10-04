# Defined interactively
function fzf_edit
    set --local rootdir (project_root)
    env --chdir $rootdir fd --type file --color=always --follow --hidden --exclude .git -0 \
    | env --chdir $rootdir fzf -0 -1 --read0 --ansi \
        --tiebreak=begin \
        --toggle-sort=ctrl-r \
        --bind 'tab:execute(bat --color=always {} | LESS= less -R)' \
        --bind "enter:execute(xdg-open {})+abort" \
        --preview-window right:70% --preview "bat --color=always {}"
end
