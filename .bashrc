# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#AndroidDev PATH
export PATH=${PATH}:~/android-sdk-linux/tools
export PATH=${PATH}:~/android-sdk-linux/platform-tools

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
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

function showgitbranch() {
  GITBRANCH=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  [ "$GITBRANCH" != "" ] && echo -n "[$GITBRANCH]"
}

function currentPath() {
  IFS='/' read -r -a directories <<< $PWD

  COUNT=$(expr ${#directories[@]} - 1)
  LATEST=${directories[@]:$COUNT}
  unset directories[0]
  unset directories[$COUNT]
  PATH=""

  for d in "${directories[@]}"
  do
    PATH+="/${d:0:1}"
  done

  if [ $COUNT -gt 3 ]
  then echo -n "$PATH/$LATEST"
  else echo -n $PWD
  fi
}

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local EXIT="$?"
    PS1=""

    local RCol='\[\033[0m\]'

    local Red='\[\033[0;31m\]'
    local BoRed='\[\033[1;31m\]'
    local BlRed='\[\033[5;31m\]'

    local Green='\[\033[0;32m\]'
    local BoGreen='\[\033[1;32m\]'
    local BlGreen='\[\033[5;32m\]'

    local Yellow='\[\033[0;33m\]'
    local BoYellow='\[\033[1;33m\]'
    local BlYellow='\[\033[5;33m\]'

    local Blue='\[\033[0;34m\]'
    local BoBlue='\[\033[1;34m\]'
    local BlBlue='\[\033[5;34m\]'

    local Cyan='\[\033[0;36m\]'
    local BoCyan='\[\033[1;36m\]'
    local BlCyan='\[\033[5;36m\]'

    local Purple='\[\033[0;35m\]'
    local BoPurple='\[\033[1;35m\]'
    local BlPurple='\[\033[5;35m\]'

    if [ $EXIT != 0 ]
    then PS1+="${Red}⬤ ${RCol}"
    else PS1+="${Green}⬤ ${RCol}"
    fi

    PS1+=" "$(date +%H:%M)" "
    PS1+="${BoYellow}\u${Blue}@${Red}\h${RCol}:"
    PS1+="${Cyan}$(currentPath)${RCol}"
    PS1+="${BoPurple}$(showgitbranch)${RCol}$ ${RCol}"
}

# if [ "$USER" == "root" ]
# then PS1='\[\033[01;37m\]$(date +%H%M) \[\033[1;33m\]\u\[\033[01;34m\]@\[\033[1;31m\]\h\[\033[01;34;m\]:\[\033[01;36m\]\w\[\033[01;35m\]\[\033[00m\]\$ '
# else PS1=$(lastStatus)'\[\033[01;37m\]$(date +%H%M) \[\033[1;33m\]\u\[\033[01;34m\]@\[\033[1;31m\]\h\[\033[01;34;m\]:\[\033[01;36m\]\w\[\033[01;35m\]$(showgitbranch)\[\033[00m\]\$ '
# fi


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
alias ll='ls -lF'
alias lla='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi