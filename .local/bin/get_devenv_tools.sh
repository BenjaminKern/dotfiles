#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$1"

curl -sL install-node.now.sh/lts | bash -s -- --prefix=$DESTDIR --yes
curl -sL https://github.com/yarnpkg/yarn/releases/download/v1.22.11/yarn-v1.22.11.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR
curl -sL https://github.com/clangd/clangd/releases/download/12.0.1/clangd-linux-12.0.1.zip | bsdtar xvf - --strip-components=1 -C $DESTDIR
curl -sL https://github.com/clangd/clangd/releases/download/12.0.1/clangd_indexing_tools-linux-12.0.1.zip | bsdtar xvf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - -C $DESTDIR/bin
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.9.0/hexyl-v0.9.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.11.0/hyperfine-v1.11.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-v0.18.2-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/sharkdp/vivid/releases/download/v0.7.0/vivid-v0.7.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-musl -o $DESTDIR/bin/sd
chmod u+x $DESTDIR/bin/sd
curl -sL https://github.com/starship/starship/releases/download/v0.56.0/starship-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - -C $DESTDIR/bin
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR
curl -sL https://github.com/austinjones/tab-rs/releases/download/v0.5.7/tab-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - -C $DESTDIR/bin
curl -sL https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
curl -sL https://github.com/bootandy/dust/releases/download/v0.6.2/dust-v0.6.2-x86_64-unknown-linux-musl.tar.gz | bsdtar xvfz - --strip-components=1 -C $DESTDIR/bin
# curl -sL https://github.com/Canop/broot/releases/download/v1.6.3/broot_1.6.3.zip| bsdtar xvf - --strip-components=1 -C $DESTDIR
