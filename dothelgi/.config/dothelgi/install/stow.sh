#!/bin/bash

OS=$(uname)

echo "🧠 Installing dotfiles for: $OS, you sexy skibidi terminal GIGACHAD 💀💦"

cd $HOME/dotfiles
pwd
stow -D */

for dir in */; do
    dir=${dir%/}  # remove trailing slash

    if [[ "$dir" == mac-* && "$OS" == "Darwin" ]]; then
        echo "🍎 Stowing mac-specific config: $dir"
        stow -v "$dir"
    elif [[ "$dir" == linux-* && "$OS" == "Linux" ]]; then
        echo "🐧 Stowing linux-specific config: $dir"
        stow -v "$dir"
    elif [[ "$dir" != mac-* && "$dir" != linux-* ]]; then
        echo "🌍 Stowing shared config: $dir"
        stow -v "$dir"
    else
        echo "💤 Skipping $dir — not for this OS."
    fi
done
