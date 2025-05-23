#!/bin/bash

ensure_eof_newline() {
    local file="$1"
    [ -f "$file" ] || { echo "💀 BRO THAT AIN'T EVEN A FILE: $file" >&2; return 2; }
    tail -c1 "$file" | read -r _ || echo >> "$file"
}

# credit to ml4w
_isInstalled() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

ensure_eof_newline pkglist_pacman
ensure_eof_newline pkglist_yay

toInstall_pacman=()
toInstall_yay=()

while IFS= read -r line; do
    if [[ $(_isInstalled "${line}") == 0 ]]; then
        echo "${line} is already installed.";
        continue;
    fi;
    toInstall_pacman+=("${line}")
done < "./pkglist_pacman"

while IFS= read -r line; do    
    if [[ $(_isInstalled "${line}") == 0 ]]; then
        echo "${line} is already installed.";
        continue;
    fi;
    toInstall_yay+=("${line}")
done < "./pkglist_yay"

if [[ "${toInstall_pacman[@]}" != "" ]] ; then
   sudo pacman -S "${toInstall_pacman[@]}" --noconfirm;
fi;
if [[ "${toInstall_yay[@]}" != "" ]] ; then
    yay -S "${toInstall_yay[@]}" --noconfirm;
fi;

echo "Copying greetd config"
sudo cp -v ./greetd/config.toml /etc/greetd/config.toml
