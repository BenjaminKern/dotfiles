#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$(readlink -e $1)"

echo "Downloading node..."
curl -sL install-node.now.sh/lts | bash -s -- --prefix=$DESTDIR --yes
echo "Downloading yarn..."
curl -sL https://github.com/yarnpkg/yarn/releases/download/v1.22.11/yarn-v1.22.11.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/12.0.1/clangd-linux-12.0.1.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/12.0.1/clangd_indexing_tools-linux-12.0.1.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading skim..."
curl -sL https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading hexyl..."
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.9.0/hexyl-v0.9.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading hyperfine..."
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.11.0/hyperfine-v1.11.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fd..."
curl -sL https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading bat..."
curl -sL https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-v0.18.2-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading vivid..."
curl -sL https://github.com/sharkdp/vivid/releases/download/v0.7.0/vivid-v0.7.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading sd..."
curl -sL https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-musl -o $DESTDIR/bin/sd
chmod u+x $DESTDIR/bin/sd
echo "Downloading starship..."
curl -sL https://github.com/starship/starship/releases/download/v0.56.0/starship-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading nvim..."
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading tab..."
curl -sL https://github.com/austinjones/tab-rs/releases/download/v0.5.7/tab-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading lsd..."
curl -sL https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading dust..."
curl -sL https://github.com/bootandy/dust/releases/download/v0.6.2/dust-v0.6.2-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading jq..."
curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o $DESTDIR/bin/jq
chmod u+x $DESTDIR/bin/jq
echo "Downloading bottom..."
curl -sL https://github.com/ClementTsang/bottom/releases/download/0.6.3/bottom_x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading rage..."
curl -sL https://github.com/str4d/rage/releases/download/v0.6.0/rage-v0.6.0-x86_64-linux.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
# echo "Downloading broot..."
# curl -sL https://github.com/Canop/broot/releases/download/v1.6.3/broot_1.6.3.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Create devenv_tools.bash..."
echo "ISBbWyAtdiBkZXZlbnZfdG9vbHNfZGlyIF1dICYmIHJldHVybgohIFtbIC1mICRkZXZlbnZfdG9vbHNfZGlyL2RldmVudl90b29scy5iYXNoIF1dICYmIHJldHVybgoKUEFUSD0kZGV2ZW52X3Rvb2xzX2Rpci9iaW46JFBBVEgKU1RBUlNISVBfQ09ORklHPSRkZXZlbnZfdG9vbHNfZGlyL2NvbmZpZy9zdGFyc2hpcC50b21sCmV2YWwgIiQoc3RhcnNoaXAgaW5pdCBiYXNoKSIKTFNfQ09MT1JTPSIkKHZpdmlkIGdlbmVyYXRlIG9uZS1kYXJrKSIKYWxpYXMgbHM9J2xzZCcKRURJVE9SPW52aW0KYWxpYXMgY2F0PSdiYXQgLS1wYWdpbmc9bmV2ZXInCgpbWyAtdiBkZXZlbnZfdG9vbHNfcHJveHkgXV0gJiYgXAogIEhUVFBfUFJPWFk9JGRldmVudl90b29sc19wcm94eSAmJiBcCiAgSFRUUFNfUFJPWFk9JGRldmVudl90b29sc19wcm94eSAmJiBcCiAgaHR0cF9wcm94eT0kZGV2ZW52X3Rvb2xzX3Byb3h5ICYmIFwKICBodHRwc19wcm94eT0kZGV2ZW52X3Rvb2xzX3Byb3h5Cg==" | base64 -d - > $DESTDIR/devenv_tools.bash

echo "Add the following lines to ~/.bashrc"
echo "devenv_tools_dir=$DESTDIR"
echo "source $DESTDIR/devenv_tools.bash"
# yarn global add pyright --prefix $DESTDIR
# yarn global add prettier --prefix $DESTDIR
