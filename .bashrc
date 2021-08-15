#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"
alias ls='lsd'
if [[ -v WSL_DISTRO_NAME ]]
then
  export SSH_SK_HELPER=/mnt/c/dev/opt/ssh/ssh-sk-helper.exe
  export SSH_SK_PROVIDER=c:\\dev\\opt\\ssh\\winhello.dll
  # Disable blinking
  echo -e "\e[2 q"
fi

source ~/.config/broot/launcher/bash/br
source ~/.local/share/tab/completion/tab.bash
eval "$(direnv hook bash)"
