# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/helgi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#custom

# Runs fastfetch on terminal open if in hyprland
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
else
    echo
    if [[ ${uname} == "Linux" ]]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

path+=('/home/helgi/.local/bin')

alias l="ls"
alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="ll -a"

alias pacman="sudo pacman"

alias mommy="git"
alias please="sudo"
alias pls="please"

alias findstr="search"
alias fs="search"
alias s="search"

alias find="find -name"
alias kaupa="sudo pacman -S"

# enable CTRL+arrowleft/arrowright to jump whole words
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word


findopen() {
    editor=code

    if [ $# -eq 0 ]; then
        echo "Usage: findopen <thing to find and open>"
        echo "Options:\n    -n <int> - opens specific find result"
        return 1
    fi

    i=1
    arguntil=()
    n_found=false
    n_arg=""

    for arg in $@; do
        if [ "$n_found" = true ]; then
            n_arg=${arg}
            break;
        fi

        if [ "$arg" != "-n" ] && [ "$n_found" != true ]; then
            ((i++))
            arguntil+=${arg}
        else
            n_found=true
            continue
        fi
    done

    # relies on "find" being aliased to "find -name"
    findout=$(find ${arguntil[@]})

    if [ "$n_found" = true ]; then
        echo "$findout" | sed -n "${n_arg}p" | xargs $editor
    elif [[ "$findout" == *$'\n'* ]]; then
        # if -n not found and find output is multiline
        echo "$findout" | nl
        wc=$(echo "$findout" | wc -l)
        echo -n "\nMULTIPLE OPTIONS TO OPEN. CHOOSE -> ALL|1|2|3... \n:> "
        read input
        if [[ "$input" =~ ^[0-9]+$ ]] && (( input >= 1 && input <= wc )); then
            # input is a number and in range
            echo "$findout" | sed -n "${input}p" | xargs code
        else
            if [[ "$input" != "all" ]]; then
                echo "input not recognised or out of range. Assuming 'all' is meant."
            fi
            # opens all instances
            echo "$findout" | xargs $editor
        fi
    else
        $editor ${findout}
    fi
}

# Custom search for finding string in a file recursively from current dir
# uses fzf, bat, rg
search() {
    if [ $# -eq 0 ]; then
        echo "Usage: search <search term>"
        return 1
    fi

    query="$*"
    # Format the ripgrep output for better readability
    selected=$(rg "$query" --line-number --color=always |
        fzf --ansi \
            --delimiter : \
            --preview "bat --style=numbers --color=always --highlight-line {2} {1}" \
            --preview-window=right:60% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --layout=reverse)

    if [ -n "$selected" ]; then
        file=$(echo "$selected" | cut -d':' -f1)
        line=$(echo "$selected" | cut -d':' -f2)
        code "$file" +"$line"
    fi
}



# Starship
eval "$(starship init zsh)"
