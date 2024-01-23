#!/usr/bin/env fish
fish_add_path -a $HOME/.cargo/bin || true

alias --save cr="cargo run --quiet && cargo clean"
