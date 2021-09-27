devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$PATH
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
eval "$(starship init bash)"
LS_COLORS="$(vivid generate one-dark)"
alias ls='lsd'
EDITOR=nvim
alias cat='bat --paging=never'
eval "$(direnv hook bash)"
eval "$(zoxide init --cmd j bash)"
eval "$(mcfly init bash)"
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=true

[[ -v devenv_tools_proxy ]] && \
  HTTP_PROXY=$devenv_tools_proxy && \
  HTTPS_PROXY=$devenv_tools_proxy && \
  http_proxy=$devenv_tools_proxy && \
  https_proxy=$devenv_tools_proxy
