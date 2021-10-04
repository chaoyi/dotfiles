function upgrade

set -l directory ~/.local/share/upgrade
set -l datafile $directory/upgrade.yaml
set -l names (yq -r 'keys[]' < $datafile)

for name in $names
    yq -r '.'$name'|[.repo, .file, .install]|@tsv' < $datafile | read -l -d\t repo file install

    set -l regex '(?<url>https:.*\\/(?<file>'(string escape --style regex $file | string replace @VER@ '(?<ver>(.*?))')'))'
    curl -s https://api.github.com/repos/$repo/releases/latest | jq -r '.assets[]|.browser_download_url' | string match -rq $regex
    or begin
        set_color red; echo failed to find latest info for $name; set_color normal
        continue
    end
    set -l version_file $directory/$name.version
    set -l old_ver (cat $version_file 2>/dev/null )
    if test "$old_ver" = "$ver"
        set_color green; echo $name is already latest at $old_ver; set_color normal
        continue
    end
    set_color red; echo upgrade $name from $old_ver to $ver; set_color normal
    cd $directory && curl -OL $url
    echo -e $install | source
    and begin
        set_color green; echo done; set_color normal
        echo $ver > $version_file
    end
end

end
