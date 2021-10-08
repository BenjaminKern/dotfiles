devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$devenv_tools_dir/git-fuzzy/bin:$PATH
source $devenv_tools_dir/config/fzf-key-bindings.bash
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"
export BAT_STYLE=gruvbox
export GF_LOG_MENU_PARAMS='--pretty="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --topo-order'
export GF_REFLOG_MENU_PARAMS='--pretty=fuzzyformat'
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
LS_COLORS="$(vivid generate one-dark)"
alias ls='lsd'
alias ff='fzf'
EDITOR=nvim
alias cat='bat --paging=never'

[[ -v devenv_tools_proxy ]] && \
  export HTTP_PROXY=$devenv_tools_proxy && \
  export HTTPS_PROXY=$devenv_tools_proxy && \
  export http_proxy=$devenv_tools_proxy && \
  export https_proxy=$devenv_tools_proxy

source $devenv_tools_dir/bin/autocomplete/bat.bash
source $devenv_tools_dir/bin/autocomplete/fd.bash-completion
source $devenv_tools_dir/bin/autocomplete/hyperfine.bash-completion
source $devenv_tools_dir/bin/autocomplete/lsd.bash-completion
source $devenv_tools_dir/bin/complete/rg.bash
source $devenv_tools_dir/bin/completion/btm.bash

# tab completion
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"
# history
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
HISTTIMEFORMAT='%F %T '

eval "$(direnv hook bash)"
eval "$(zoxide init --cmd j bash)"
eval "$(starship init bash)"
