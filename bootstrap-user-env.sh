#!/usr/bin/env sh

dotfiles="$(dirname "$(which "$0")")"
HOME=/home/dimatomp

[[ -L $HOME/.nixpkgs ]] || ln -s $dotfiles/nixpkgs $HOME/.nixpkgs

mkdir -p $HOME/.config
[[ -L $HOME/.config/bspwm ]] || ln -s $dotfiles/bspwm $HOME/.config/bspwm
[[ -L $HOME/.config/sxhkd ]] || ln -s $dotfiles/sxhkd $HOME/.config/sxhkd

ln -sf $dotfiles/.zshrc $dotfiles/.vimrc $dotfiles/.vim-scripts $dotfiles/IMG_2363_cropped.JPG $HOME/
