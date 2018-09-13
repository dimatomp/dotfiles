#!/usr/bin/env bash

dotfiles=$HOME/Projects/dotfiles
HOME=/home/dimatomp

[[ -L $HOME/.nixpkgs ]] || ln -s $dotfiles/nixpkgs $HOME/.nixpkgs
for src in $dotfiles/etc/nixos/*.patch
do
    dst=$HOME/.nixpkgs/$(basename $src)
    [[ -L $dst ]] || ln -s $src $dst
done

mkdir -p $HOME/.config
[[ -L $HOME/.config/bspwm ]] || ln -s $dotfiles/bspwm $HOME/.config/bspwm
[[ -L $HOME/.config/sxhkd ]] || ln -s $dotfiles/sxhkd $HOME/.config/sxhkd

ln -sf $dotfiles/.zshrc $dotfiles/.vimrc $dotfiles/.vim-scripts $dotfiles/IMG_2363_cropped.JPG $HOME/
