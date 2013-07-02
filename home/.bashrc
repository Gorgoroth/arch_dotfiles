#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# $XDG_CONFIG_HOME defines the base directory relative to which
# user specific configuration files should be stored. If
# $XDG_CONFIG_HOME is either not set or empty, a default equal to
# $HOME/.config should be used.
if test "x$XDG_CONFIG_HOME" = "x" ; then
    XDG_CONFIG_HOME=$HOME/.config
    export XDG_CONFIG_HOME
fi
[ -d "$XDG_CONFIG_HOME" ] || mkdir "$XDG_CONFIG_HOME"


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
