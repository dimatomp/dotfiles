#!/usr/bin/env sh

dotfiles="$(dirname "$(which "$0")")"

[[ -L $HOME/.nixpkgs ]] || ln -s $dotfiles/nixpkgs $HOME/.nixpkgs

mkdir -p /home/dimatomp/.config
[[ -L $HOME/.config/bspwm ]] || ln -s $dotfiles/bspwm $HOME/.config/bspwm
[[ -L $HOME/.config/sxhkd ]] || ln -s $dotfiles/sxhkd $HOME/.config/sxhkd
