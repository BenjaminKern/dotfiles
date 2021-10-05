#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$(readlink -e $1)"

mkdir -p $DESTDIR/bin
PATH=$DESTDIR/bin:$PATH
mkdir -p $DESTDIR/config

echo "Downloading nvim..."
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading vim plugged..."
curl -sL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o $DESTDIR/share/nvim/runtime/pack/dist/opt/plug/plugin/plug.vim --create-dirs
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/init.lua -o $DESTDIR/share/nvim/runtime/lua/devenv_config.lua
echo "Downloading node..."
curl -sL install-node.now.sh | bash -s -- --prefix=$DESTDIR --yes
echo "Downloading yarn..."
curl -sL https://github.com/yarnpkg/yarn/releases/download/v1.22.15/yarn-v1.22.15.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/13.0.0/clangd-linux-13.0.0.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/13.0.0/clangd_indexing_tools-linux-13.0.0.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading skim..."
curl -sL https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading fzf..."
curl -sL https://github.com/junegunn/fzf/releases/download/0.27.2/fzf-0.27.2-linux_amd64.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading hexyl..."
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.9.0/hexyl-v0.9.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading hyperfine..."
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.11.0/hyperfine-v1.11.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fd..."
curl -sL https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading bat..."
curl -sL https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-v0.18.3-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading vivid..."
curl -sL https://github.com/sharkdp/vivid/releases/download/v0.7.0/vivid-v0.7.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading sd..."
curl -sL https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-musl -o $DESTDIR/bin/sd
chmod u+x $DESTDIR/bin/sd
echo "Downloading starship..."
curl -sL https://github.com/starship/starship/releases/download/v0.58.0/starship-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading lsd..."
curl -sL https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading dust..."
curl -sL https://github.com/bootandy/dust/releases/download/v0.7.5/dust-v0.7.5-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading jq..."
curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o $DESTDIR/bin/jq
chmod u+x $DESTDIR/bin/jq
echo "Downloading bottom..."
curl -sL https://github.com/ClementTsang/bottom/releases/download/0.6.4/bottom_x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading age..."
curl -sL https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz| bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading direnv..."
curl -sL https://github.com/direnv/direnv/releases/download/v2.28.0/direnv.linux-amd64 -o $DESTDIR/bin/direnv
chmod u+x $DESTDIR/bin/direnv
echo "Downloading gdbinit-gef..."
curl -sL https://github.com/hugsy/gef/raw/master/gef.py -o $DESTDIR/config/gdbinit-gef.py
echo "Downloading abduco..."
curl -sL https://github.com/BenjaminKern/dotfiles/raw/main/.local/pkg/abduco-0.6-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading alacritty..."
curl -sL https://github.com/BenjaminKern/dotfiles/raw/main/.local/pkg/alacritty-0.9.0-unknown-linux-gnu.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading zoxide..."
curl -sL https://github.com/ajeetdsouza/zoxide/releases/download/v0.7.5/zoxide-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading delta..."
curl -sL https://github.com/dandavison/delta/releases/download/0.8.3/delta-0.8.3-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading ttyd..."
curl -sL https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 -o $DESTDIR/bin/ttyd
chmod u+x $DESTDIR/bin/ttyd
echo "Downloading forgit..."
curl -sL git.io/forgit -o $DESTDIR/config/forgit.plugin.bash
echo "Downloading fzf.keybindings.bash..."
curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash -o $DESTDIR/config/fzf-key-bindings.bash
echo "Downloading fd ignore file..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/devenv/.fd-ignore -o $DESTDIR/share/nvim/.fd-ignore
echo "Downloading devenv_tools.bash..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/devenv/devenv_tools.bash -o $DESTDIR/devenv_tools.bash
echo "Downloading starship.toml..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/starship.toml -o $DESTDIR/config/starship.toml
yarn config set global-folder $DESTDIR/config/yarn/global
echo "Installing pyright"
yarn global add pyright --prefix $DESTDIR
echo "Installing prettier"
yarn global add prettier --prefix $DESTDIR
echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.gdbinit"
echo "source $DESTDIR/config/gdbinit-gef.py"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
# echo "Downloading broot..."
# curl -sL https://github.com/Canop/broot/releases/download/v1.6.3/broot_1.6.3.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
