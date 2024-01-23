#!/usr/bin/env fish
if ! command -qs tmux
    exit
end

test -d ~/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

alias --save tn='tmux-new'
alias --save ta='tmux attach'
alias --save tls='tmux ls'
alias --save tat='tmux attach -t'
alias --save tns='tmux new-session -s'
