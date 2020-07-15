# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -v'
alias ssh='ssh -v'
alias mpv.no-video="mpv --no-video"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# TxGVNN/dots
# $cat this-file >> ~/.bashrc
##PS1
color='32'
if [ "$(id -u)" -eq 0 ]; then
    color='31'
fi
if ! declare -f "__git_ps1" >/dev/null; then
    function __git_ps1(){ echo "";}
fi
export GIT_PS1_SHOWDIRTYSTATE=true
PS1="\$(__service_ps)\n\[\e[0;${color}m\]+\[\e[1;30m\](\[\e[0;${color}m\]\u\[\e[0;36m\]@\h\[\e[1;30m\])\$(if [[ \$? == 0 ]]; then echo \"\[\e[1;32m\]-\"; else echo \"\[\e[1;31m\]-\"; fi)\[\e[0m\]\[\e[1;30m\](\[\e[0;34m\]\w\[\e[1;30m\])-(\[\e[0;33m\]\t\[\e[1;30m\]\[\e[1;30m\])\$(__git_ps1)\n\[\e[0;${color}m\]+>\[\e[0m\]"

function __service_ps(){
    local ret=$?
    # torsock on
    if env | grep torsocks -q ; then
        printf "-\e[1;30m(\e[1;30mtor\e[1;30m)\e[0m"
    fi
    return $ret
}
function ps1(){
    if [[ $PS1 != *"$1"* ]]; then
        PS1="-\[\e[1;30m\](\[\e[0;35m\]"$1"\[\e[1;30m\])\[\e[0m\]"$PS1
    fi
}

declare -f "cdenv" > /dev/null || function cdenv(){
    if [ -z "$1" ]; then
        cd || exit 1
    else
        cd "$1"
    fi

    # .bin
    if [ -e .bin ]; then
        if [[ $PATH != *"$(pwd)/.bin"* ]]; then
            ps1 ".bin"
            export PATH=$(pwd)/.bin:$PATH
        fi
        if [ -e .bin/env ]; then
            . .bin/env
        fi
    fi

    # Makefile
    if [ -e Makefile ]; then
        ps1 "make"
    else
        PS1=$(echo $PS1 | sed 's/-\\\[\\e\[1;30m\\\](\\\[\\e\[0;35m\\\]make\\\[\\e\[1;30m\\\])//g')
    fi

    # virtualenv
    if [ -e bin ]; then
        if [[ $PATH != *"$(pwd)/bin"* ]]; then
            ps1 bin
            export PATH=$(pwd)/bin:$PATH
        fi
        if [ -e bin/activate ]; then
            . bin/activate
        fi
    fi

    # vagrant
    if [ -e Vagrantfile ]; then
        if [[ $PS1 != *"vagrant"* ]]; then
            ps1 vagrant
        fi
    else
        PS1=$(echo $PS1 | sed 's/-\\\[\\e\[1;30m\\\](\\\[\\e\[0;35m\\\]vagrant\\\[\\e\[1;30m\\\])//g')
    fi
}

function cdtmp(){
    cd "$(mktemp -d -t ${USER}_$(date +%F_%H-%M)_XXX)" || exit 1
}

function lstmp(){
    ls /tmp/"$USER"*
}

function mkcd(){
    if [ $# -ne 1 ]; then
        echo "Usage: mkcd DIR"
    fi
    mkdir "$1" && cd "$1"
}

# SSH and screen
function sshscreen(){
    ssh "$@" -v -t 'if screen -ls | grep gtx -q ; then screen -x gtx ;else screen -S gtx ;fi'
}

# SSH and screen
function sshtmux(){
    ssh "$@" -v -t 'if tmux ls | grep gtx -q ; then tmux at -t gtx ;else tmux new -s gtx ;fi'
}

# Alias
alias cd="cdenv"
alias em="emacs -nw"
# Export
# export HISTTIMEFORMAT="%F %T "
## Check pseudoterminal or not?
export TERM=xterm-256color
if [[ $(tty) != */dev/pts/* ]]; then
    export TERM=linux
fi
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
