#!/usr/bin/env bash

set -eux

export COMMIT_DATE="$(date '+%B %-d, %Y, at %H:%M:%S') on $(uname -s)"

# Push Nix config changes
cd ~/.config/nix
git pull
nix flake update || :
git add -A
git commit -m "${COMMIT_DATE}" || :
git push

# Push all other ~/.config changes
cd ~/.config
git pull
git add -A
git commit -m "${COMMIT_DATE}" || :
git push || :

# Synchronize Logseq notes
cd ~/Desktop/logseq
git pull
git submodule update --init --recursive --remote
git add -A
git commit -m "${COMMIT_DATE}" || :
git push

# Code reuse, that's it
export REBUILD_FLAGS=-j auto --show-trace

# Rebuild the Nix system
if [ -d /etc/nixos ]; then
  cd /etc/nixos
  sudo git pull
  sudo nixos-rebuild switch -v --upgrade-all --install-bootloader ${REBUILD_FLAGS}
  # nix shell nixpkgs#efibootmgr nixpkgs#refind -c refind-install
else
  cd ~/.config/nix
  darwin-rebuild switch --flake .#macbook-macos --keep-going ${REBUILD_FLAGS}
fi

# Collect garbage
nix-collect-garbage -j auto --delete-older-than 14d > /dev/null 2>&1 &
