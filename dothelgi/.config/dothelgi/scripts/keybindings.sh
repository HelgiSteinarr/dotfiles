#!/bin/bash
#  _              _     _           _ _                  
# | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___  
# | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __| 
# |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \ 
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/ 
#           |___/                             |___/      
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

# Reads hyprland keybindings from binds.conf and displays them with rofi

# TODO: clean up list to remove laptop fn keys like audio plus minus etc that bloat window - Helgi Steinarr   

config_file=~/.config/hypr/conf/binds.conf
echo "Reading from: $config_file"

keybinds=""

# Detect Start String
while read -r line
do
    if [[ "$line" == "bind"* ]]; then

        line="$(echo "$line" | sed 's/$mainMod/SUPER/g')"
        line="$(echo "$line" | sed 's/bind = //g')"
        line="$(echo "$line" | sed 's/bindm = //g')"

        IFS='#' 
        read -a strarr <<<"$line" 
        kb_str=${strarr[0]}
        cm_str=${strarr[1]}

        IFS=',' 
        read -a kbarr <<<"$kb_str" 

        item="${kbarr[0]}  + ${kbarr[1]}"$'\r'"${cm_str:1}"
        keybinds=$keybinds$item$'\n'
    fi 
done < "$config_file"

sleep 0.2
rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" <<< "$keybinds"