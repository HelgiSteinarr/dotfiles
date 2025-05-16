#!/bin/bash

ensure_eof_newline() {
    local file="$1"
    [ -f "$file" ] || { echo "💀 BRO THAT AIN'T EVEN A FILE: $file" >&2; return 2; }
    tail -c1 "$file" | read -r _ || echo >> "$file"
}

ensure_eof_newline pkglist_pacman
ensure_eof_newline pkglist_yay

packages_pacman=()
packages_yay=()

while IFS= read -r line; do
    packages_pacman+=("${line}")
done < "./pkglist_pacman"

while IFS= read -r line; do
    packages_yay+=("${line}")
done < "./pkglist_yay"

echo "${packages_pacman[@]}"
echo "Lolooololol"
echo "${packages_yay[@]}"

sudo pacman -S "${packages_pacman[@]}" --noconfirm;
# yay -S $packages_yay --noconfirm


# TODO: The config file below should be put in /etc/greetd/config.toml
#
# [terminal]
# # The VT to run the greeter on. Can be "next", "current" or a number
# # designating the VT.
# vt = 1
# 
# # The default session, also known as the greeter.
# [default_session]
# 
# # `agreety` is the bundled agetty/login-lookalike. You can replace `/bin/sh`
# # with whatever you want started, such as `sway`.
# command = "agreety --cmd /bin/sh"
# 
# # The user to run the command as. The privileges this user must have depends
# # on the greeter. A graphical greeter may for example require the user to be
# # in the `video` group.
# user = "greeter"
# 
# [initial_session]
# command = "hyprland"
# user = "helgi"