#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export DOCKER_BUILDKIT=1
eval "$(starship init bash)"
alias ls='lsd'
# PS1='[\u@\h \W]\$ '
if [[ -v WSL_DISTRO_NAME ]]
then
  export SSH_SK_HELPER=/mnt/c/dev/opt/ssh/ssh-sk-helper.exe
  export SSH_SK_PROVIDER=c:\\dev\\opt\\ssh\\winhello.dll
fi

source ~/.config/broot/launcher/bash/br
source ~/.local/share/tab/completion/tab.bash
eval "$(direnv hook bash)"
# Disable blinking
echo -e "\e[2 q"
