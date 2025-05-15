#!/bin/bash

# by HELGI STEINARR JÚLÍUSSON | 2025

STATUS=$(
    cat /sys/class/power_supply/BAT0/status
); 
CAP=$(
    cat /sys/class/power_supply/BAT0/capacity
); 

if [[ $STATUS != 'Charging' ]]; then
    if [[ $CAP -lt 15 ]]; then
        ICON='🪫'
    else
        ICON='🔋'
    fi
else
    ICON='⚡'
fi

echo "$ICON $CAP%"