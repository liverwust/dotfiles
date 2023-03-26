# Source this file to use Vim settings without clobbering the home dir.
# This is for shared user accounts at work.

alias vim="vim -u $HOME/.homesick/repos/dotvim/home/.vimrc"

# https://github.com/liverwust/dotvim
# https://github.com/sigurdga/ls-colors-solarized/blob/master/dircolors
eval `dircolors "$HOME/.homesick/repos/dotvim/dircolors"`
