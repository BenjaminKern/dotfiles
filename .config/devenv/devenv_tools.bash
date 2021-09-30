devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$PATH
source $devenv_tools_dir/config/sensible.bash
source $devenv_tools_dir/config/forgit.plugin.sh
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
