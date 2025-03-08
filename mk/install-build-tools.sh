#!/usr/bin/env bash
#
# Copyright 2023 Brian Smith.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

set -eux -o pipefail
IFS=$'\n\t'

wget https://download.qemu.org/qemu-9.2.2.tar.xz -P downloads

version=v28.0.0
wget https://github.com/bytecodealliance/wasmtime/releases/download/${version}/wasmtime-${version}-x86_64-linux.tar.xz -P downloads

sha256sum --check sha256sums

mkdir -p qemu-build
tar --strip-components=1 --directory=qemu-build     -xf downloads/qemu-9.2.2.tar.xz
# sudo apt install bison flex libglib2.0-dev python3-tomli
(cd qemu-build; ./configure && make)
mkdir -p qemu/bin
cp qemu-build/build/qemu-bundle/usr/local/bin/{qemu-aarch64*,qemu-arm*,qemu-i386,qemu-mips*,qemu-ppc*,qemu-riscv*,qemu-s390x,qemu-x86_64,qemu-xtensa*} qemu/bin/
cp -r qemu-build/build/qemu-bundle/usr/local/lib qemu/

mkdir -p wasmtime
tar --strip-components=1 --directory=wasmtime -xf \
  downloads/wasmtime-${version}-x86_64-linux.tar.xz \
  wasmtime-${version}-x86_64-linux/{README.md,wasmtime}
git update-index --chmod=+x qemu/wasmtime
git update-index --chmod=+x wasmtime/wasmtime
