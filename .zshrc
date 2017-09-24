# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list ''
zstyle :compinstall filename '/home/dimatomp/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1024
SAVEHIST=1024
setopt extendedglob
unsetopt nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

#zstyle ':completion:*:*:pacman:option-u-1:files'

autoload -U zkbd 
source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
bindkey "${key[Home]}"   beginning-of-line
bindkey "${key[End]}"    end-of-line
bindkey "${key[Delete]}" delete-char

autoload -U colors && colors
autoload -U promptinit && promptinit

PROMPT="%{${fg[green]}%}%n@%m %{$fg_bold[blue]%}%1~ %{$fg_bold[green]%}%#%{${reset_color}%} "

export EDITOR="vim"
#export ANDROID_HOME="/home/dimatomp/soft/android-sdk-linux"
#export GRADLE_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

function pstbuild() {
    DIR=$(basename $(pwd))
    latex $DIR.tex && dvips $DIR.dvi && ps2pdf $DIR.ps && rm $DIR.dvi $DIR.ps && xdg-open $DIR.pdf
}
function pdfbuild() {
    DIR=$(basename $(pwd))
    pdflatex $DIR.tex && xdg-open $DIR.pdf
}
alias ll='ls -la'
alias dh='df -h'
alias ssh-github='eval $(ssh-agent) && ssh-add ~/.ssh/github'
alias emacs='emacs -nw'
alias clone-shell='sakura `pwd` & disown'

function mkcd() {
    mkdir $1 && cd $1
}

function office2pdf() {
    libreoffice -pt pdf "$1"
    cp /var/spool/cups-pdf/dimatomp/*.pdf .
}

#export PUUSH_API_KEY=DAB228360195BA824019E69DB5934BC7
