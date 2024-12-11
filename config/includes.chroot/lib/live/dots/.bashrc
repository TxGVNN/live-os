# ~/.bashrc: executed by bash(1) for non-login shells.
#export HISTTIMEFORMAT="%F %T "
color_prompt=yes

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

# gtx
if [ -z "$GTX_DIR" ]; then
    export GTX_DIR="$HOME/.gxt/rofs"
    export PATH="$GTX_DIR/bin:$PATH"
fi
if [ -d "$GTX_DIR" ]; then
    pushd "$GTX_DIR" > /dev/null 2>&1
    . etc/bashrc
    popd > /dev/null 2>&1
fi

# Check pseudoterminal or not?
export TERM=xterm-256color
if [[ $(tty) != */dev/pts/* ]]; then
    export TERM=linux
fi

if [ -t 0 ] && [ "$GTX_DIR" ]; then
    txgvnn
fi

# debian
export DEBEMAIL="txgvnn@gmail.com"
export DEBFULLNAME="Giap Tran"
alias dquilt="quilt --quiltrc=${GTX_DIR}/etc/quiltrc-dpkg"
complete -F _quilt_completion $_quilt_complete_opt dquilt

# ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'
#shopt -q login_shell && echo 'Login shell' || echo 'No login shell'
export VAGRANT_DEFAULT_PROVIDER=libvirt
# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;
[ -f ~/.bashrc.local ] && source ~/.bashrc.local # not commit this file

if [ ! -d /gnu ]; then
    echo "Setup Guix..."
    sudo tar -xf ~/guix.tar.xz -C /
fi
if [ ! -e ~/.guix-profile ]; then
    ln -svf $(ls -d /gnu/store/*profile) ~/.guix-profile
    ~/.guix-profile/bin/oops-link
fi

export GUIX_PROFILE=~/.guix-profile
if [ -e ${GUIX_PROFILE}/etc/profile ]; then
    source ${GUIX_PROFILE}/etc/profile
fi
export GUIX_LOCPATH=${GUIX_PROFILE}/lib/locale
if type -p direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi
if [ -e /etc/ssl/certs/ca-certificates.crt ]; then
    export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
fi
