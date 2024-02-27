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

# Rebuild the Nix system
if [ -d /etc/nixos ]; then
  cd /etc/nixos
  sudo git pull
  sudo nixos-rebuild switch -v --upgrade-all --install-bootloader -j auto
  # nix shell nixpkgs#efibootmgr nixpkgs#refind -c refind-install
else
  darwin-rebuild switch --flake ~/.config/nix --keep-going -j auto
fi

# Collect garbage
nix-collect-garbage -j auto --delete-older-than 14d > /dev/null 2>&1 &
