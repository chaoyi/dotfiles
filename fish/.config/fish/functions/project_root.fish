function project_root
    set --local rootdir (emacsclient --eval "(projectile-root-bottom-up \""(pwd)"\")")
    if test $rootdir = "nil"
        set rootdir (pwd)
    else
        set rootdir (string sub -s 2 -e -2 $rootdir) # remove starting " and trailing /"
    end
    echo $rootdir
end
