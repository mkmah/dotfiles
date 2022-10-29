#!/bin/bash

DOTFILES_PATH=~/.dotfiles
ZSH_SRC_PATH=$DOTFILES_PATH/zsh

# . "$ZSH_SRC_PATH"/.prompt
. "$ZSH_SRC_PATH"/.aliases
. "$ZSH_SRC_PATH"/.functions

. "$ZSH_SRC_PATH"/.osx

# edit this folder
alias dot="cd ~/.dotfiles"
# reload
alias vz="vim ~/.zshrc";
alias cz="code ~/.zshrc";
alias sz="source ~/.zshrc; clear; echo '~/.zshrc reloaded.';";

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/Users/$USER/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
  python
  docker
  colored-man-pages
  colorize
  pip
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# CDPATH ALTERATIONS
CDPATH=.:$HOME:$HOME/workspace:$HOME/go/src/github.com/mkmah

export GPG_TTY=$(tty)

export PATH="/usr/local/opt/libpq/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"

export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH

export GPG_TTY=$(tty)

export PNPM_HOME="/Users/$USER/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
export PATH=/Users/manoj/flutter/bin:$PATH

# pnpm
export PNPM_HOME="/Users/$USER/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
