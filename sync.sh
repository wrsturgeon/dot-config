# Update everything installed with Nix
nix profile upgrade '.*'
nix-collect-garbage

# Update Rust tooling
rustup self update || :
rustup update || :

# Synchronize Logseq notes
pushd ~/Desktop/logseq
git pull
git submodule update --init --remote --recursive
git add -A
git commit -m "$(date '+%B %-d, %Y, at %H:%M:%S')"
git push
popd

# Synchronize `~/.config`
pushd ~/.config
git pull
git submodule update --init --remote --recursive
git add -A
git commit -m "Mac laptop on $(date '+%B %-d, %Y, at %H:%M:%S')"
git push
popd

# Homebrew
brew autoremove
brew upgrade
brew autoremove
brew cleanup
