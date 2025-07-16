#!/bin/bash

if [[ $# -eq 0 ]]; then
echo "Error no argument passed"
exit 1
fi
if test ! -d $1; then
echo "Such dir is not exist"
exit 1
fi
dir="$1"
printarry() {

        local -n givenList=$1
        local i=0
        for item in "${givenList[@]}"; do
            if [ $i -eq 0 ]; then
                echo -n "\"$item\""
                i=1
            else
                echo -n ", \"$item\""
            fi
        done
        }
myfunc() {
        local files=()
        local directories=()
        local special_files=()
        local special_directories=()
        local blacklist=()
        local dir="$1"
        local base_dir="$2"
        local rel_path=$(realpath --relative-to="$base_dir" "$dir")
        local rel_path1="."

        if [[ "$rel_path" != "." ]]; then
        rel_path1=".."
        local count=$(grep -o '/' <<< "$rel_path" | wc -l)
                local i=0
        while [[ $i -lt $count ]]; do
                rel_path1+="/.."
            ((i++))
                done
        fi

if [[ -f "$1/_blacklist" ]]; then
    while IFS= read -r line ; do
        blacklist+=("$line")
    done < "$1/_blacklist"
fi
        if [[ -f "$1/_special" ]]; then
            while IFS= read -r line; do
                if [[ -f "$1/$line" ]]; then
                    special_files+=("$line")
                elif [[ -d "$1/$line" ]]; then
                    special_directories+=("$line")
                fi
            done < "$1/_special"
        fi
        for x in $dir/*; do
        x=$(basename "$x")
        if [[ " ${blacklist[*]} " =~ " ${x} " ]] || [[ " ${special_files[*]} " =~ " ${x} " ]] || [[ " ${special_directories[*]} " =~ " ${x} " ]]; then
        continue
        fi
        if [[ "$x" == "_special" ]] || [[ "$x" == "_blacklist" ]] ||  [[ "$x" == "index.json" ]]; then
        continue
        fi
        if   [[ -f "$1/$x" ]] ; then
            files+=("$x")
        elif [[ -d "$1/$x" ]] ; then
            directories+=("$x")
        fi
        done
        IFS=$'\n' files=($(sort <<<"${files[*]}"))
    IFS=$'\n' directories=($(sort <<<"${directories[*]}"))
    IFS=$'\n' special_files=($(sort <<<"${special_files[*]}"))
    IFS=$'\n' special_directories=($(sort <<<"${special_directories[*]}"))
    unset IFS

    echo "{"
    echo " \"files\" : [$(printarry files)]"
    echo " \"directory\" : [$(printarry directories)]"
    echo " \"special_files\" : [$(printarry special_files)]"
    echo " \"special_directory\" : [$(printarry special_directories)]"
    echo " \"outer\" : [\"$rel_path1\"]"
    echo "}"
 }
IFS=$'\n'
find "$dir" -type d | while read -r directory; do
        touch index.json
        myfunc "$directory" "$dir" > "$directory"/index.json
done
