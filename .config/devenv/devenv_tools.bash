devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$PATH
source $devenv_tools_dir/config/forgit.plugin.bash
source $devenv_tools_dir/config/fzf-key-bindings.bash
export FZF_DEFAULT_COMMAND='fd --type f'
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
eval "$(starship init bash)"
LS_COLORS="$(vivid generate one-dark)"
alias ls='lsd'
EDITOR=nvim
alias cat='bat --paging=never'
eval "$(direnv hook bash)"
eval "$(zoxide init --cmd j bash)"

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
