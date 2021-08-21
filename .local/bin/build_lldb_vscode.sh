#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$(readlink -e $1)"

echo "Downloading llvm sources..."
git clone  --depth=1 --branch=release/13.x https://github.com/llvm/llvm-project
cmake -S llvm-project/llvm -DLLVM_TARGETS_TO_BUILD="AArch64;X86" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lldb" -G Ninja -B lldb-vscode-build -DCMAKE_INSTALL_PREFIX=$DESTDIR
cmake --build lldb-vscode-build --target lldb-vscode
cmake --build lldb-vscode-build --target lldb-server
